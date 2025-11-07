# actual data rates (in gbps) of various display interfaces
@{
DataRates = @{
    HDMI = @{ # <-- HDMI (High-Definition Multimedia Interface)
        HDMI21_48 = 42.67  # <-- HDMI 2.1 48gbps  encoding: 16/18
        HDMI22_64 = 56.83  # <-- HDMI 2.2 64gbps  encoding: 16/18
        HDMI22_80 = 71.04  # <-- HDMI 2.2 80gbps  encoding: 16/18
        HDMI22_96 = 85.25  # <-- HDMI 2.2 96gbps  encoding: 16/18
    }

    DisplayPort = @{ # <-- Display Port
        DP14_32   = 25.92  # <-- Display Port 1.4 32gbps           encoding: 8/10
        DP21_40   = 38.68  # <-- Display Port 2.1 UHBR10 40gbps    encoding: 128/132
        DP21_54   = 52.22  # <-- Display Port 2.1 UHBR13.5 54gbps  encoding: 128/132
        DP21_80   = 77.37  # <-- Display Port 2.1 UHBR20 80gbps    encoding: 128/132
    }

    Thunderbolt = @{ # <-- Thunderbolt (*rough estimates, could not find exact numbers)
        TB4_40    = 35.3   # <-- ThunderBolt 4 40gbps    encoding: ???
        TB5_80    = 70.6   # <-- ThunderBolt 5 80gbps    encoding: ???
        TB5_120   = 106    # <-- ThunderBolt 5 120gbps   encoding: ???
    }
    
    GPMI = @{ # <-- GPMI (General Purpose Media Interface)  [this is a standard developed by Chinese companies]
        GPMI_96   = '???'  # <-- GPMI Type-C 96gbps
        GPMI_192  = '???'  # <-- GPMI Type-B 192gbps
    }
}

}