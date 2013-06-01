module NiseBOSHVagrant

  class NetworkInterface
    def self.detect
      device_list = `VBoxManage list bridgedifs`
      raise "VBoxManage command not found" unless $?.success?

      device_list.split(/^$\n/).inject([]) { |devices, device|
        device = Hash[*device.split("\n").map { |line| line.match(/^([^:]+): *(.*)/).captures }.flatten]
        kernel_device_name = device["Name"].split(":")[0]

        ifconfig = `ifconfig #{kernel_device_name}`
        if match = ifconfig.match(/inet ([.0-9]+) netmask 0x([0-9a-f]+) broadcast/) # BSD
          address = match[1]
          mask = match[2].unpack("a2a2a2a2").map { |block| block.hex }.join(".")
          gateway = `route -n get -ifscope #{kernel_device_name} 0.0.0.0 | grep gateway | awk '{print $2}'`.strip
        elsif match = ifconfig.match(/inet addr:([.0-9]+)  Bcast:[.0-9]+  Mask:([.0-9]+)/) # Linux
          address = match[1]
          mask = match[2]
          gateway = `ip route show oif #{kernel_device_name} | grep 'default via' | awk '{print $3}'`.strip
        else
          next devices
        end

        devices << self.new(device["Name"], address, mask, gateway)
        devices
      }
    end

    def self.find(ip_address)
      self.detect.find do |device|
        device.same_network?(ip_address)
      end
    end

    attr_reader :name, :vbox_name, :ip_address, :network_mask, :gateway

    def initialize(vbox_name, ip_address, network_mask, gateway)
      @vbox_name = vbox_name
      @ip_address = ip_address
      @network_mask = network_mask
      @gateway = gateway
    end

    def name()
      vbox_name.split(":")[0]
    end

    def same_network?(address)
      (self.class.ip_address_to_int(@ip_address) & self.class.ip_address_to_int(@network_mask)) ==
      (self.class.ip_address_to_int(address) & self.class.ip_address_to_int(@network_mask))
    end

    def self.ip_address_to_int(ip_address)
        ip_address.split(".").map{|s|s.to_i}.pack("C*").unpack("N")[0]
    end
  end
end
