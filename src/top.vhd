--------------------------------------------------------------------------------
--! @file top.vhd
--! @brief Toplevel module for TE0741 eval board.
--! @author Alberto Collu, Yuan Mei
--!
--! Target Device: Kintex-7 XC7K160T-2FFG676C
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
LIBRARY UNISIM;
USE UNISIM.VComponents.ALL;

LIBRARY work;
USE work.utility.ALL;

ENTITY top IS
  GENERIC (
    ENABLE_DEBUG       : boolean := false;
    ENABLE_GIG_ETH     : boolean := true;
    ENABLE_TEN_GIG_ETH : boolean := true
  );
  PORT (
    SYS_RST          : IN    std_logic;
    SYS_CLK_P        : IN    std_logic;
    SYS_CLK_N        : IN    std_logic;
    USER_CLK_P       : IN    std_logic;  --! 156.250 MHz
    USER_CLK_N       : IN    std_logic;
    SGMIICLK_Q0_P    : IN    std_logic;  --! 125 MHz, for GTP/GTH/GTX
    SGMIICLK_Q0_N    : IN    std_logic;
    SI5324CLK_P      : IN    std_logic;
    SI5324CLK_N      : IN    std_logic;
    --
    LED8Bit          : OUT   std_logic_vector(7 DOWNTO 0);
    DIPSw4Bit        : IN    std_logic_vector(3 DOWNTO 0);
    BTN5Bit          : IN    std_logic_vector(4 DOWNTO 0);
    USER_SMA_CLOCK_P : OUT   std_logic;
    USER_SMA_CLOCK_N : OUT   std_logic;
    USER_SMA_GPIO_P  : OUT   std_logic;
    USER_SMA_GPIO_N  : OUT   std_logic;
    SI5324_RSTn      : OUT   std_logic;
    -- UART via usb
    USB_RX           : OUT   std_logic;
    USB_TX           : IN    std_logic;
    -- SFP
    SFP_TX_P         : OUT   std_logic;
    SFP_TX_N         : OUT   std_logic;
    SFP_RX_P         : IN    std_logic;
    SFP_RX_N         : IN    std_logic;
    SFP_LOS_LS       : IN    std_logic;
    SFP_TX_DISABLE_N : OUT   std_logic;
    -- Gigbit eth interface (RGMII)
    PHY_RESET_N      : OUT   std_logic;
    RGMII_TXD        : OUT   std_logic_vector(3 DOWNTO 0);
    RGMII_TX_CTL     : OUT   std_logic;
    RGMII_TXC        : OUT   std_logic;
    RGMII_RXD        : IN    std_logic_vector(3 DOWNTO 0);
    RGMII_RX_CTL     : IN    std_logic;
    RGMII_RXC        : IN    std_logic;
    MDIO             : INOUT std_logic;
    MDC              : OUT   std_logic;
    -- SDRAM
    DDR3_DQ          : INOUT std_logic_vector(63 DOWNTO 0);
    DDR3_DQS_P       : INOUT std_logic_vector(7 DOWNTO 0);
    DDR3_DQS_N       : INOUT std_logic_vector(7 DOWNTO 0);
    -- Outputs
    DDR3_ADDR        : OUT   std_logic_vector(13 DOWNTO 0);
    DDR3_BA          : OUT   std_logic_vector(2 DOWNTO 0);
    DDR3_RAS_N       : OUT   std_logic;
    DDR3_CAS_N       : OUT   std_logic;
    DDR3_WE_N        : OUT   std_logic;
    DDR3_RESET_N     : OUT   std_logic;
    DDR3_CK_P        : OUT   std_logic_vector(0 DOWNTO 0);
    DDR3_CK_N        : OUT   std_logic_vector(0 DOWNTO 0);
    DDR3_CKE         : OUT   std_logic_vector(0 DOWNTO 0);
    DDR3_CS_N        : OUT   std_logic_vector(0 DOWNTO 0);
    DDR3_DM          : OUT   std_logic_vector(7 DOWNTO 0);
    DDR3_ODT         : OUT   std_logic_vector(0 DOWNTO 0);
    --
    I2C_SCL          : INOUT std_logic;
    I2C_SDA          : INOUT std_logic;
    -- FMC HPC
    FMC_HPC_HA_P     :INOUT    std_logic_vector(23 DOWNTO 0);
    FMC_HPC_HA_N     :INOUT    std_logic_vector(23 DOWNTO 0);
    FMC_HPC_LA_P     :INOUT    std_logic_vector(33 DOWNTO 0);
    FMC_HPC_LA_N     :INOUT    std_logic_vector(33 DOWNTO 0);
    -- FMC LPC
    FMC_LPC_LA_P     :INOUT    std_logic_vector(33 DOWNTO 0);
    FMC_LPC_LA_N     :INOUT    std_logic_vector(33 DOWNTO 0)

    -- Configuration pins
    R11   DXN_0
    R12   DXP_0
    N11   VREFN_0
    P12   VREFP_0
    N12   VP_0
    P11   VN_0
    C8    CCLK_0
    L8    TCK_0
    N8    TMS_0
    R7    TDO_0
    R6    TDI_0
    G7    INIT_B_0
    P6    PROGRAM_B_0
    P7    CFGBVS_0
    J7    DONE_0
    P5    M2_0
    T5    M0_0
    T2    M1_0

    -- IO single ended and differential
    U21   IO_0_12
    U22   IO_L1P_T0_12
    V22   IO_L1N_T0_12
    U24   IO_L2P_T0_12
    U25   IO_L2N_T0_12
    V23   IO_L3P_T0_DQS_12
    V24   IO_L3N_T0_DQS_12
    U26   IO_L4P_T0_12
    V26   IO_L4N_T0_12
    W25   IO_L5P_T0_12
    W26   IO_L5N_T0_12
    V21   IO_L6P_T0_12
    W21   IO_L6N_T0_VREF_12
    AA25  IO_L7P_T1_12
    AB25  IO_L7N_T1_12
    W23   IO_L8P_T1_12
    W24   IO_L8N_T1_12
    AB26  IO_L9P_T1_DQS_12
    AC26  IO_L9N_T1_DQS_12
    Y25   IO_L10P_T1_12
    Y26   IO_L10N_T1_12
    AA23  IO_L11P_T1_SRCC_12
    AB24  IO_L11N_T1_SRCC_12            1                  12    NA            NA                  HR        7K70T
    Y23   IO_L12P_T1_MRCC_12            1                  12    NA            NA                  HR        7K70T
    AA24  IO_L12N_T1_MRCC_12            1                  12    NA            NA                  HR        7K70T
    Y22   IO_L13P_T2_MRCC_12            2                  12    NA            NA                  HR        7K70T
    AA22  IO_L13N_T2_MRCC_12            2                  12    NA            NA                  HR        7K70T
    AC23  IO_L14P_T2_SRCC_12            2                  12    NA            NA                  HR        7K70T
    AC24  IO_L14N_T2_SRCC_12            2                  12    NA            NA                  HR        7K70T
    W20   IO_L15P_T2_DQS_12             2                  12    NA            NA                  HR        7K70T
    Y21   IO_L15N_T2_DQS_12             2                  12    NA            NA                  HR        7K70T
    AD23  IO_L16P_T2_12                 2                  12    NA            NA                  HR        7K70T
    AD24  IO_L16N_T2_12                 2                  12    NA            NA                  HR        7K70T
    AB22  IO_L17P_T2_12                 2                  12    NA            NA                  HR        7K70T
    AC22  IO_L17N_T2_12                 2                  12    NA            NA                  HR        7K70T
    AB21  IO_L18P_T2_12                 2                  12    NA            NA                  HR        7K70T
    AC21  IO_L18N_T2_12                 2                  12    NA            NA                  HR        7K70T
    AD21  IO_L19P_T3_12                 3                  12    NA            NA                  HR        7K70T
    AE21  IO_L19N_T3_VREF_12            3                  12    NA            NA                  HR        7K70T
    AF24  IO_L20P_T3_12                 3                  12    NA            NA                  HR        7K70T
    AF25  IO_L20N_T3_12                 3                  12    NA            NA                  HR        7K70T
    AD26  IO_L21P_T3_DQS_12             3                  12    NA            NA                  HR        7K70T
    AE26  IO_L21N_T3_DQS_12             3                  12    NA            NA                  HR        7K70T
    AE23  IO_L22P_T3_12                 3                  12    NA            NA                  HR        7K70T
    AF23  IO_L22N_T3_12                 3                  12    NA            NA                  HR        7K70T
    AD25  IO_L23P_T3_12                 3                  12    NA            NA                  HR        7K70T
    AE25  IO_L23N_T3_12                 3                  12    NA            NA                  HR        7K70T
    AE22  IO_L24P_T3_12                 3                  12    NA            NA                  HR        7K70T
    AF22  IO_L24N_T3_12                 3                  12    NA            NA                  HR        7K70T
    Y20   IO_25_12                      NA                 12    NA            NA                  HR        7K70T
    N16   IO_0_13                       NA                 13    NA            NA                  HR        NA
    K25   IO_L1P_T0_13                  0                  13    NA            NA                  HR        NA
    K26   IO_L1N_T0_13                  0                  13    NA            NA                  HR        NA
    R26   IO_L2P_T0_13                  0                  13    NA            NA                  HR        NA
    P26   IO_L2N_T0_13                  0                  13    NA            NA                  HR        NA
    M25   IO_L3P_T0_DQS_13              0                  13    NA            NA                  HR        NA
    L25   IO_L3N_T0_DQS_13              0                  13    NA            NA                  HR        NA
    P24   IO_L4P_T0_13                  0                  13    NA            NA                  HR        NA
    N24   IO_L4N_T0_13                  0                  13    NA            NA                  HR        NA
    N26   IO_L5P_T0_13                  0                  13    NA            NA                  HR        NA
    M26   IO_L5N_T0_13                  0                  13    NA            NA                  HR        NA
    R25   IO_L6P_T0_13                  0                  13    NA            NA                  HR        NA
    P25   IO_L6N_T0_VREF_13             0                  13    NA            NA                  HR        NA
    N19   IO_L7P_T1_13                  1                  13    NA            NA                  HR        NA
    M20   IO_L7N_T1_13                  1                  13    NA            NA                  HR        NA
    M24   IO_L8P_T1_13                  1                  13    NA            NA                  HR        NA
    L24   IO_L8N_T1_13                  1                  13    NA            NA                  HR        NA
    P19   IO_L9P_T1_DQS_13              1                  13    NA            NA                  HR        NA
    P20   IO_L9N_T1_DQS_13              1                  13    NA            NA                  HR        NA
    M21   IO_L10P_T1_13                 1                  13    NA            NA                  HR        NA
    M22   IO_L10N_T1_13                 1                  13    NA            NA                  HR        NA
    P23   IO_L11P_T1_SRCC_13            1                  13    NA            NA                  HR        NA
    N23   IO_L11N_T1_SRCC_13            1                  13    NA            NA                  HR        NA
    N21   IO_L12P_T1_MRCC_13            1                  13    NA            NA                  HR        NA
    N22   IO_L12N_T1_MRCC_13            1                  13    NA            NA                  HR        NA
    R21   IO_L13P_T2_MRCC_13            2                  13    NA            NA                  HR        NA
    P21   IO_L13N_T2_MRCC_13            2                  13    NA            NA                  HR        NA
    R22   IO_L14P_T2_SRCC_13            2                  13    NA            NA                  HR        NA
    R23   IO_L14N_T2_SRCC_13            2                  13    NA            NA                  HR        NA
    T24   IO_L15P_T2_DQS_13             2                  13    NA            NA                  HR        NA
    T25   IO_L15N_T2_DQS_13             2                  13    NA            NA                  HR        NA
    T20   IO_L16P_T2_13                 2                  13    NA            NA                  HR        NA
    R20   IO_L16N_T2_13                 2                  13    NA            NA                  HR        NA
    T22   IO_L17P_T2_13                 2                  13    NA            NA                  HR        NA
    T23   IO_L17N_T2_13                 2                  13    NA            NA                  HR        NA
    U19   IO_L18P_T2_13                 2                  13    NA            NA                  HR        NA
    U20   IO_L18N_T2_13                 2                  13    NA            NA                  HR        NA
    T18   IO_L19P_T3_13                 3                  13    NA            NA                  HR        NA
    T19   IO_L19N_T3_VREF_13            3                  13    NA            NA                  HR        NA
    P16   IO_L20P_T3_13                 3                  13    NA            NA                  HR        NA
    N17   IO_L20N_T3_13                 3                  13    NA            NA                  HR        NA
    R16   IO_L21P_T3_DQS_13             3                  13    NA            NA                  HR        NA
    R17   IO_L21N_T3_DQS_13             3                  13    NA            NA                  HR        NA
    N18   IO_L22P_T3_13                 3                  13    NA            NA                  HR        NA
    M19   IO_L22N_T3_13                 3                  13    NA            NA                  HR        NA
    U17   IO_L23P_T3_13                 3                  13    NA            NA                  HR        NA
    T17   IO_L23N_T3_13                 3                  13    NA            NA                  HR        NA
    R18   IO_L24P_T3_13                 3                  13    NA            NA                  HR        NA
    P18   IO_L24N_T3_13                 3                  13    NA            NA                  HR        NA
    U16   IO_25_13                      NA                 13    NA            NA                  HR        NA
    K21   IO_0_14                       NA                 14    NA            NA                  HR        NA
    B24   IO_L1P_T0_D00_MOSI_14         0                  14    NA            NA                  HR        NA
    A25   IO_L1N_T0_D01_DIN_14          0                  14    NA            NA                  HR        NA
    B22   IO_L2P_T0_D02_14              0                  14    NA            NA                  HR        NA
    A22   IO_L2N_T0_D03_14              0                  14    NA            NA                  HR        NA
    B25   IO_L3P_T0_DQS_PUDC_B_14       0                  14    NA            NA                  HR        NA
    B26   IO_L3N_T0_DQS_EMCCLK_14       0                  14    NA            NA                  HR        NA
    A23   IO_L4P_T0_D04_14              0                  14    NA            NA                  HR        NA
    A24   IO_L4N_T0_D05_14              0                  14    NA            NA                  HR        NA
    D26   IO_L5P_T0_D06_14              0                  14    NA            NA                  HR        NA
    C26   IO_L5N_T0_D07_14              0                  14    NA            NA                  HR        NA
    C23   IO_L6P_T0_FCS_B_14            0                  14    NA            NA                  HR        NA
    C24   IO_L6N_T0_D08_VREF_14         0                  14    NA            NA                  HR        NA
    D21   IO_L7P_T1_D09_14              1                  14    NA            NA                  HR        NA
    C22   IO_L7N_T1_D10_14              1                  14    NA            NA                  HR        NA
    B20   IO_L8P_T1_D11_14              1                  14    NA            NA                  HR        NA
    A20   IO_L8N_T1_D12_14              1                  14    NA            NA                  HR        NA
    E21   IO_L9P_T1_DQS_14              1                  14    NA            NA                  HR        NA
    E22   IO_L9N_T1_DQS_D13_14          1                  14    NA            NA                  HR        NA
    C21   IO_L10P_T1_D14_14             1                  14    NA            NA                  HR        NA
    B21   IO_L10N_T1_D15_14             1                  14    NA            NA                  HR        NA
    D23   IO_L11P_T1_SRCC_14            1                  14    NA            NA                  HR        NA
    D24   IO_L11N_T1_SRCC_14            1                  14    NA            NA                  HR        NA
    F22   IO_L12P_T1_MRCC_14            1                  14    NA            NA                  HR        NA
    E23   IO_L12N_T1_MRCC_14            1                  14    NA            NA                  HR        NA
    G22   IO_L13P_T2_MRCC_14            2                  14    NA            NA                  HR        NA
    F23   IO_L13N_T2_MRCC_14            2                  14    NA            NA                  HR        NA
    G24   IO_L14P_T2_SRCC_14            2                  14    NA            NA                  HR        NA
    F24   IO_L14N_T2_SRCC_14            2                  14    NA            NA                  HR        NA
    E25   IO_L15P_T2_DQS_RDWR_B_14      2                  14    NA            NA                  HR        NA
    D25   IO_L15N_T2_DQS_DOUT_CSO_B_14  2                  14    NA            NA                  HR        NA
    G25   IO_L16P_T2_CSI_B_14           2                  14    NA            NA                  HR        NA
    G26   IO_L16N_T2_A15_D31_14         2                  14    NA            NA                  HR        NA
    F25   IO_L17P_T2_A14_D30_14         2                  14    NA            NA                  HR        NA
    E26   IO_L17N_T2_A13_D29_14         2                  14    NA            NA                  HR        NA
    J26   IO_L18P_T2_A12_D28_14         2                  14    NA            NA                  HR        NA
    H26   IO_L18N_T2_A11_D27_14         2                  14    NA            NA                  HR        NA
    H21   IO_L19P_T3_A10_D26_14         3                  14    NA            NA                  HR        NA
    G21   IO_L19N_T3_A09_D25_VREF_14    3                  14    NA            NA                  HR        NA
    H23   IO_L20P_T3_A08_D24_14         3                  14    NA            NA                  HR        NA
    H24   IO_L20N_T3_A07_D23_14         3                  14    NA            NA                  HR        NA
    J21   IO_L21P_T3_DQS_14             3                  14    NA            NA                  HR        NA
    H22   IO_L21N_T3_DQS_A06_D22_14     3                  14    NA            NA                  HR        NA
    J24   IO_L22P_T3_A05_D21_14         3                  14    NA            NA                  HR        NA
    J25   IO_L22N_T3_A04_D20_14         3                  14    NA            NA                  HR        NA
    L22   IO_L23P_T3_A03_D19_14         3                  14    NA            NA                  HR        NA
    K22   IO_L23N_T3_A02_D18_14         3                  14    NA            NA                  HR        NA
    K23   IO_L24P_T3_A01_D17_14         3                  14    NA            NA                  HR        NA
    J23   IO_L24N_T3_A00_D16_14         3                  14    NA            NA                  HR        NA
    L23   IO_25_14                      NA                 14    NA            NA                  HR        NA
    K15   IO_0_15                       NA                 15    NA            NA                  HR        NA
    C16   IO_L1P_T0_AD0P_15             0                  15    NA            NA                  HR        NA
    B16   IO_L1N_T0_AD0N_15             0                  15    NA            NA                  HR        NA
    A18   IO_L2P_T0_AD8P_15             0                  15    NA            NA                  HR        NA
    A19   IO_L2N_T0_AD8N_15             0                  15    NA            NA                  HR        NA
    B17   IO_L3P_T0_DQS_AD1P_15         0                  15    NA            NA                  HR        NA
    A17   IO_L3N_T0_DQS_AD1N_15         0                  15    NA            NA                  HR        NA
    C19   IO_L4P_T0_AD9P_15             0                  15    NA            NA                  HR        NA
    B19   IO_L4N_T0_AD9N_15             0                  15    NA            NA                  HR        NA
    C17   IO_L5P_T0_AD2P_15             0                  15    NA            NA                  HR        NA
    C18   IO_L5N_T0_AD2N_15             0                  15    NA            NA                  HR        NA
    D15   IO_L6P_T0_15                  0                  15    NA            NA                  HR        NA
    D16   IO_L6N_T0_VREF_15             0                  15    NA            NA                  HR        NA
    H16   IO_L7P_T1_AD10P_15            1                  15    NA            NA                  HR        NA
    G16   IO_L7N_T1_AD10N_15            1                  15    NA            NA                  HR        NA
    G15   IO_L8P_T1_AD3P_15             1                  15    NA            NA                  HR        NA
    F15   IO_L8N_T1_AD3N_15             1                  15    NA            NA                  HR        NA
    J15   IO_L9P_T1_DQS_AD11P_15        1                  15    NA            NA                  HR        NA
    J16   IO_L9N_T1_DQS_AD11N_15        1                  15    NA            NA                  HR        NA
    E15   IO_L10P_T1_AD4P_15            1                  15    NA            NA                  HR        NA
    E16   IO_L10N_T1_AD4N_15            1                  15    NA            NA                  HR        NA
    G17   IO_L11P_T1_SRCC_AD12P_15      1                  15    NA            NA                  HR        NA
    F18   IO_L11N_T1_SRCC_AD12N_15      1                  15    NA            NA                  HR        NA
    F17   IO_L12P_T1_MRCC_AD5P_15       1                  15    NA            NA                  HR        NA
    E17   IO_L12N_T1_MRCC_AD5N_15       1                  15    NA            NA                  HR        NA
    E18   IO_L13P_T2_MRCC_15            2                  15    NA            NA                  HR        NA
    D18   IO_L13N_T2_MRCC_15            2                  15    NA            NA                  HR        NA
    H17   IO_L14P_T2_SRCC_15            2                  15    NA            NA                  HR        NA
    H18   IO_L14N_T2_SRCC_15            2                  15    NA            NA                  HR        NA
    D19   IO_L15P_T2_DQS_15             2                  15    NA            NA                  HR        NA
    D20   IO_L15N_T2_DQS_ADV_B_15       2                  15    NA            NA                  HR        NA
    G19   IO_L16P_T2_A28_15             2                  15    NA            NA                  HR        NA
    F20   IO_L16N_T2_A27_15             2                  15    NA            NA                  HR        NA
    F19   IO_L17P_T2_A26_15             2                  15    NA            NA                  HR        NA
    E20   IO_L17N_T2_A25_15             2                  15    NA            NA                  HR        NA
    H19   IO_L18P_T2_A24_15             2                  15    NA            NA                  HR        NA
    G20   IO_L18N_T2_A23_15             2                  15    NA            NA                  HR        NA
    K20   IO_L19P_T3_A22_15             3                  15    NA            NA                  HR        NA
    J20   IO_L19N_T3_A21_VREF_15        3                  15    NA            NA                  HR        NA
    J18   IO_L20P_T3_A20_15             3                  15    NA            NA                  HR        NA
    J19   IO_L20N_T3_A19_15             3                  15    NA            NA                  HR        NA
    L19   IO_L21P_T3_DQS_15             3                  15    NA            NA                  HR        NA
    L20   IO_L21N_T3_DQS_A18_15         3                  15    NA            NA                  HR        NA
    K16   IO_L22P_T3_A17_15             3                  15    NA            NA                  HR        NA
    K17   IO_L22N_T3_A16_15             3                  15    NA            NA                  HR        NA
    M17   IO_L23P_T3_FOE_B_15           3                  15    NA            NA                  HR        NA
    L18   IO_L23N_T3_FWE_B_15           3                  15    NA            NA                  HR        NA
    L17   IO_L24P_T3_RS1_15             3                  15    NA            NA                  HR        NA
    K18   IO_L24N_T3_RS0_15             3                  15    NA            NA                  HR        NA
    M16   IO_25_15                      NA                 15    NA            NA                  HR        NA
    J8    IO_0_16                       NA                 16    NA            NA                  HR        NA
    H9    IO_L1P_T0_16                  0                  16    NA            NA                  HR        NA
    H8    IO_L1N_T0_16                  0                  16    NA            NA                  HR        NA
    G10   IO_L2P_T0_16                  0                  16    NA            NA                  HR        NA
    G9    IO_L2N_T0_16                  0                  16    NA            NA                  HR        NA
    J13   IO_L3P_T0_DQS_16              0                  16    NA            NA                  HR        NA
    H13   IO_L3N_T0_DQS_16              0                  16    NA            NA                  HR        NA
    J11   IO_L4P_T0_16                  0                  16    NA            NA                  HR        NA
    J10   IO_L4N_T0_16                  0                  16    NA            NA                  HR        NA
    H14   IO_L5P_T0_16                  0                  16    NA            NA                  HR        NA
    G14   IO_L5N_T0_16                  0                  16    NA            NA                  HR        NA
    H12   IO_L6P_T0_16                  0                  16    NA            NA                  HR        NA
    H11   IO_L6N_T0_VREF_16             0                  16    NA            NA                  HR        NA
    F9    IO_L7P_T1_16                  1                  16    NA            NA                  HR        NA
    F8    IO_L7N_T1_16                  1                  16    NA            NA                  HR        NA
    D9    IO_L8P_T1_16                  1                  16    NA            NA                  HR        NA
    D8    IO_L8N_T1_16                  1                  16    NA            NA                  HR        NA
    A9    IO_L9P_T1_DQS_16              1                  16    NA            NA                  HR        NA
    A8    IO_L9N_T1_DQS_16              1                  16    NA            NA                  HR        NA
    C9    IO_L10P_T1_16                 1                  16    NA            NA                  HR        NA
    B9    IO_L10N_T1_16                 1                  16    NA            NA                  HR        NA
    G11   IO_L11P_T1_SRCC_16            1                  16    NA            NA                  HR        NA
    F10   IO_L11N_T1_SRCC_16            1                  16    NA            NA                  HR        NA
    E10   IO_L12P_T1_MRCC_16            1                  16    NA            NA                  HR        NA
    D10   IO_L12N_T1_MRCC_16            1                  16    NA            NA                  HR        NA
    C12   IO_L13P_T2_MRCC_16            2                  16    NA            NA                  HR        NA
    C11   IO_L13N_T2_MRCC_16            2                  16    NA            NA                  HR        NA
    E11   IO_L14P_T2_SRCC_16            2                  16    NA            NA                  HR        NA
    D11   IO_L14N_T2_SRCC_16            2                  16    NA            NA                  HR        NA
    F14   IO_L15P_T2_DQS_16             2                  16    NA            NA                  HR        NA
    F13   IO_L15N_T2_DQS_16             2                  16    NA            NA                  HR        NA
    G12   IO_L16P_T2_16                 2                  16    NA            NA                  HR        NA
    F12   IO_L16N_T2_16                 2                  16    NA            NA                  HR        NA
    D14   IO_L17P_T2_16                 2                  16    NA            NA                  HR        NA
    D13   IO_L17N_T2_16                 2                  16    NA            NA                  HR        NA
    E13   IO_L18P_T2_16                 2                  16    NA            NA                  HR        NA
    E12   IO_L18N_T2_16                 2                  16    NA            NA                  HR        NA
    C14   IO_L19P_T3_16                 3                  16    NA            NA                  HR        NA
    C13   IO_L19N_T3_VREF_16            3                  16    NA            NA                  HR        NA
    B12   IO_L20P_T3_16                 3                  16    NA            NA                  HR        NA
    B11   IO_L20N_T3_16                 3                  16    NA            NA                  HR        NA
    B14   IO_L21P_T3_DQS_16             3                  16    NA            NA                  HR        NA
    A14   IO_L21N_T3_DQS_16             3                  16    NA            NA                  HR        NA
    B10   IO_L22P_T3_16                 3                  16    NA            NA                  HR        NA
    A10   IO_L22N_T3_16                 3                  16    NA            NA                  HR        NA
    B15   IO_L23P_T3_16                 3                  16    NA            NA                  HR        NA
    A15   IO_L23N_T3_16                 3                  16    NA            NA                  HR        NA
    A13   IO_L24P_T3_16                 3                  16    NA            NA                  HR        NA
    A12   IO_L24N_T3_16                 3                  16    NA            NA                  HR        NA
    J14   IO_25_16                      NA                 16    NA            NA                  HR        NA
    V13   IO_0_VRN_32                   NA                 32    0             NA                  HP        7K70T
    AE17  IO_L1P_T0_32                  0                  32    0             NA                  HP        7K70T
    AF17  IO_L1N_T0_32                  0                  32    0             NA                  HP        7K70T
    AF14  IO_L2P_T0_32                  0                  32    0             NA                  HP        7K70T
    AF15  IO_L2N_T0_32                  0                  32    0             NA                  HP        7K70T
    AE18  IO_L3P_T0_DQS_32              0                  32    0             NA                  HP        7K70T
    AF18  IO_L3N_T0_DQS_32              0                  32    0             NA                  HP        7K70T
    AD15  IO_L4P_T0_32                  0                  32    0             NA                  HP        7K70T
    AE15  IO_L4N_T0_32                  0                  32    0             NA                  HP        7K70T
    AF19  IO_L5P_T0_32                  0                  32    0             NA                  HP        7K70T
    AF20  IO_L5N_T0_32                  0                  32    0             NA                  HP        7K70T
    AD16  IO_L6P_T0_32                  0                  32    0             NA                  HP        7K70T
    AE16  IO_L6N_T0_VREF_32             0                  32    0             NA                  HP        7K70T
    AA14  IO_L7P_T1_32                  1                  32    0             NA                  HP        7K70T
    AA15  IO_L7N_T1_32                  1                  32    0             NA                  HP        7K70T
    AC14  IO_L8P_T1_32                  1                  32    0             NA                  HP        7K70T
    AD14  IO_L8N_T1_32                  1                  32    0             NA                  HP        7K70T
    Y15   IO_L9P_T1_DQS_32              1                  32    0             NA                  HP        7K70T
    Y16   IO_L9N_T1_DQS_32              1                  32    0             NA                  HP        7K70T
    AB14  IO_L10P_T1_32                 1                  32    0             NA                  HP        7K70T
    AB15  IO_L10N_T1_32                 1                  32    0             NA                  HP        7K70T
    AA17  IO_L11P_T1_SRCC_32            1                  32    0             NA                  HP        7K70T
    AA18  IO_L11N_T1_SRCC_32            1                  32    0             NA                  HP        7K70T
    AB16  IO_L12P_T1_MRCC_32            1                  32    0             NA                  HP        7K70T
    AC16  IO_L12N_T1_MRCC_32            1                  32    0             NA                  HP        7K70T
    AC18  IO_L13P_T2_MRCC_32            2                  32    0             NA                  HP        7K70T
    AD18  IO_L13N_T2_MRCC_32            2                  32    0             NA                  HP        7K70T
    AB17  IO_L14P_T2_SRCC_32            2                  32    0             NA                  HP        7K70T
    AC17  IO_L14N_T2_SRCC_32            2                  32    0             NA                  HP        7K70T
    AD20  IO_L15P_T2_DQS_32             2                  32    0             NA                  HP        7K70T
    AE20  IO_L15N_T2_DQS_32             2                  32    0             NA                  HP        7K70T
    AA19  IO_L16P_T2_32                 2                  32    0             NA                  HP        7K70T
    AA20  IO_L16N_T2_32                 2                  32    0             NA                  HP        7K70T
    AC19  IO_L17P_T2_32                 2                  32    0             NA                  HP        7K70T
    AD19  IO_L17N_T2_32                 2                  32    0             NA                  HP        7K70T
    AB19  IO_L18P_T2_32                 2                  32    0             NA                  HP        7K70T
    AB20  IO_L18N_T2_32                 2                  32    0             NA                  HP        7K70T
    Y17   IO_L19P_T3_32                 3                  32    0             NA                  HP        7K70T
    Y18   IO_L19N_T3_VREF_32            3                  32    0             NA                  HP        7K70T
    V16   IO_L20P_T3_32                 3                  32    0             NA                  HP        7K70T
    V17   IO_L20N_T3_32                 3                  32    0             NA                  HP        7K70T
    W18   IO_L21P_T3_DQS_32             3                  32    0             NA                  HP        7K70T
    W19   IO_L21N_T3_DQS_32             3                  32    0             NA                  HP        7K70T
    W15   IO_L22P_T3_32                 3                  32    0             NA                  HP        7K70T
    W16   IO_L22N_T3_32                 3                  32    0             NA                  HP        7K70T
    V18   IO_L23P_T3_32                 3                  32    0             NA                  HP        7K70T
    V19   IO_L23N_T3_32                 3                  32    0             NA                  HP        7K70T
    V14   IO_L24P_T3_32                 3                  32    0             NA                  HP        7K70T
    W14   IO_L24N_T3_32                 3                  32    0             NA                  HP        7K70T
    W13   IO_25_VRP_32                  NA                 32    0             NA                  HP        7K70T
    U9    IO_0_VRN_33                   NA                 33    0             NA                  HP        NA
    V11   IO_L1P_T0_33                  0                  33    0             NA                  HP        NA
    W11   IO_L1N_T0_33                  0                  33    0             NA                  HP        NA
    V8    IO_L2P_T0_33                  0                  33    0             NA                  HP        NA
    V7    IO_L2N_T0_33                  0                  33    0             NA                  HP        NA
    W10   IO_L3P_T0_DQS_33              0                  33    0             NA                  HP        NA
    W9    IO_L3N_T0_DQS_33              0                  33    0             NA                  HP        NA
    Y8    IO_L4P_T0_33                  0                  33    0             NA                  HP        NA
    Y7    IO_L4N_T0_33                  0                  33    0             NA                  HP        NA
    Y11   IO_L5P_T0_33                  0                  33    0             NA                  HP        NA
    Y10   IO_L5N_T0_33                  0                  33    0             NA                  HP        NA
    V9    IO_L6P_T0_33                  0                  33    0             NA                  HP        NA
    W8    IO_L6N_T0_VREF_33             0                  33    0             NA                  HP        NA
    AE7   IO_L7P_T1_33                  1                  33    0             NA                  HP        NA
    AF7   IO_L7N_T1_33                  1                  33    0             NA                  HP        NA
    AA8   IO_L8P_T1_33                  1                  33    0             NA                  HP        NA
    AA7   IO_L8N_T1_33                  1                  33    0             NA                  HP        NA
    AC8   IO_L9P_T1_DQS_33              1                  33    0             NA                  HP        NA
    AD8   IO_L9N_T1_DQS_33              1                  33    0             NA                  HP        NA
    AB7   IO_L10P_T1_33                 1                  33    0             NA                  HP        NA
    AC7   IO_L10N_T1_33                 1                  33    0             NA                  HP        NA
    AA9   IO_L11P_T1_SRCC_33            1                  33    0             NA                  HP        NA
    AB9   IO_L11N_T1_SRCC_33            1                  33    0             NA                  HP        NA
    AC9   IO_L12P_T1_MRCC_33            1                  33    0             NA                  HP        NA
    AD9   IO_L12N_T1_MRCC_33            1                  33    0             NA                  HP        NA
    AB11  IO_L13P_T2_MRCC_33            2                  33    0             NA                  HP        NA
    AC11  IO_L13N_T2_MRCC_33            2                  33    0             NA                  HP        NA
    AA10  IO_L14P_T2_SRCC_33            2                  33    0             NA                  HP        NA
    AB10  IO_L14N_T2_SRCC_33            2                  33    0             NA                  HP        NA
    AB12  IO_L15P_T2_DQS_33             2                  33    0             NA                  HP        NA
    AC12  IO_L15N_T2_DQS_33             2                  33    0             NA                  HP        NA
    AA13  IO_L16P_T2_33                 2                  33    0             NA                  HP        NA
    AA12  IO_L16N_T2_33                 2                  33    0             NA                  HP        NA
    AC13  IO_L17P_T2_33                 2                  33    0             NA                  HP        NA
    AD13  IO_L17N_T2_33                 2                  33    0             NA                  HP        NA
    Y13   IO_L18P_T2_33                 2                  33    0             NA                  HP        NA
    Y12   IO_L18N_T2_33                 2                  33    0             NA                  HP        NA
    AD11  IO_L19P_T3_33                 3                  33    0             NA                  HP        NA
    AE11  IO_L19N_T3_VREF_33            3                  33    0             NA                  HP        NA
    AD10  IO_L20P_T3_33                 3                  33    0             NA                  HP        NA
    AE10  IO_L20N_T3_33                 3                  33    0             NA                  HP        NA
    AE12  IO_L21P_T3_DQS_33             3                  33    0             NA                  HP        NA
    AF12  IO_L21N_T3_DQS_33             3                  33    0             NA                  HP        NA
    AE8   IO_L22P_T3_33                 3                  33    0             NA                  HP        NA
    AF8   IO_L22N_T3_33                 3                  33    0             NA                  HP        NA
    AE13  IO_L23P_T3_33                 3                  33    0             NA                  HP        NA
    AF13  IO_L23N_T3_33                 3                  33    0             NA                  HP        NA
    AF10  IO_L24P_T3_33                 3                  33    0             NA                  HP        NA
    AF9   IO_L24N_T3_33                 3                  33    0             NA                  HP        NA
    V12   IO_25_VRP_33                  NA                 33    0             NA                  HP        NA
    U4    IO_0_VRN_34                   NA                 34    0             NA                  HP        NA
    U6    IO_L1P_T0_34                  0                  34    0             NA                  HP        NA
    U5    IO_L1N_T0_34                  0                  34    0             NA                  HP        NA
    U2    IO_L2P_T0_34                  0                  34    0             NA                  HP        NA
    U1    IO_L2N_T0_34                  0                  34    0             NA                  HP        NA
    W6    IO_L3P_T0_DQS_34              0                  34    0             NA                  HP        NA
    W5    IO_L3N_T0_DQS_34              0                  34    0             NA                  HP        NA
    V3    IO_L4P_T0_34                  0                  34    0             NA                  HP        NA
    W3    IO_L4N_T0_34                  0                  34    0             NA                  HP        NA
    U7    IO_L5P_T0_34                  0                  34    0             NA                  HP        NA
    V6    IO_L5N_T0_34                  0                  34    0             NA                  HP        NA
    V4    IO_L6P_T0_34                  0                  34    0             NA                  HP        NA
    W4    IO_L6N_T0_VREF_34             0                  34    0             NA                  HP        NA
    Y3    IO_L7P_T1_34                  1                  34    0             NA                  HP        NA
    Y2    IO_L7N_T1_34                  1                  34    0             NA                  HP        NA
    V2    IO_L8P_T1_34                  1                  34    0             NA                  HP        NA
    V1    IO_L8N_T1_34                  1                  34    0             NA                  HP        NA
    AB1   IO_L9P_T1_DQS_34              1                  34    0             NA                  HP        NA
    AC1   IO_L9N_T1_DQS_34              1                  34    0             NA                  HP        NA
    W1    IO_L10P_T1_34                 1                  34    0             NA                  HP        NA
    Y1    IO_L10N_T1_34                 1                  34    0             NA                  HP        NA
    AB2   IO_L11P_T1_SRCC_34            1                  34    0             NA                  HP        NA
    AC2   IO_L11N_T1_SRCC_34            1                  34    0             NA                  HP        NA
    AA3   IO_L12P_T1_MRCC_34            1                  34    0             NA                  HP        NA
    AA2   IO_L12N_T1_MRCC_34            1                  34    0             NA                  HP        NA
    AA4   IO_L13P_T2_MRCC_34            2                  34    0             NA                  HP        NA
    AB4   IO_L13N_T2_MRCC_34            2                  34    0             NA                  HP        NA
    AC4   IO_L14P_T2_SRCC_34            2                  34    0             NA                  HP        NA
    AC3   IO_L14N_T2_SRCC_34            2                  34    0             NA                  HP        NA
    AA5   IO_L15P_T2_DQS_34             2                  34    0             NA                  HP        NA
    AB5   IO_L15N_T2_DQS_34             2                  34    0             NA                  HP        NA
    AB6   IO_L16P_T2_34                 2                  34    0             NA                  HP        NA
    AC6   IO_L16N_T2_34                 2                  34    0             NA                  HP        NA
    Y6    IO_L17P_T2_34                 2                  34    0             NA                  HP        NA
    Y5    IO_L17N_T2_34                 2                  34    0             NA                  HP        NA
    AD6   IO_L18P_T2_34                 2                  34    0             NA                  HP        NA
    AD5   IO_L18N_T2_34                 2                  34    0             NA                  HP        NA
    AD4   IO_L19P_T3_34                 3                  34    0             NA                  HP        NA
    AD3   IO_L19N_T3_VREF_34            3                  34    0             NA                  HP        NA
    AD1   IO_L20P_T3_34                 3                  34    0             NA                  HP        NA
    AE1   IO_L20N_T3_34                 3                  34    0             NA                  HP        NA
    AF5   IO_L21P_T3_DQS_34             3                  34    0             NA                  HP        NA
    AF4   IO_L21N_T3_DQS_34             3                  34    0             NA                  HP        NA
    AE3   IO_L22P_T3_34                 3                  34    0             NA                  HP        NA
    AE2   IO_L22N_T3_34                 3                  34    0             NA                  HP        NA
    AE6   IO_L23P_T3_34                 3                  34    0             NA                  HP        NA
    AE5   IO_L23N_T3_34                 3                  34    0             NA                  HP        NA
    AF3   IO_L24P_T3_34                 3                  34    0             NA                  HP        NA
    AF2   IO_L24N_T3_34                 3                  34    0             NA                  HP        NA
    T7    IO_25_VRP_34                  NA                 34    0             NA                  HP        NA
    H2    MGTXTXP3_115                  NA                 115   NA            NA                  GTX       NA
    J4    MGTXRXP3_115                  NA                 115   NA            NA                  GTX       NA
    H1    MGTXTXN3_115                  NA                 115   NA            NA                  GTX       NA
    J3    MGTXRXN3_115                  NA                 115   NA            NA                  GTX       NA
    K2    MGTXTXP2_115                  NA                 115   NA            NA                  GTX       NA
    L4    MGTXRXP2_115                  NA                 115   NA            NA                  GTX       NA
    K1    MGTXTXN2_115                  NA                 115   NA            NA                  GTX       NA
    H6    MGTREFCLK0P_115               NA                 115   NA            NA                  GTX       NA
    L3    MGTXRXN2_115                  NA                 115   NA            NA                  GTX       NA
    M5    MGTAVTTRCAL_115               NA                 115   NA            NA                  GTX       NA
    H5    MGTREFCLK0N_115               NA                 115   NA            NA                  GTX       NA
    M6    MGTRREF_115                   NA                 115   NA            NA                  GTX       NA
    K5    MGTREFCLK1N_115               NA                 115   NA            NA                  GTX       NA
    K6    MGTREFCLK1P_115               NA                 115   NA            NA                  GTX       NA
    M2    MGTXTXP1_115                  NA                 115   NA            NA                  GTX       NA
    N4    MGTXRXP1_115                  NA                 115   NA            NA                  GTX       NA
    M1    MGTXTXN1_115                  NA                 115   NA            NA                  GTX       NA
    N3    MGTXRXN1_115                  NA                 115   NA            NA                  GTX       NA
    P2    MGTXTXP0_115                  NA                 115   NA            NA                  GTX       NA
    R4    MGTXRXP0_115                  NA                 115   NA            NA                  GTX       NA
    P1    MGTXTXN0_115                  NA                 115   NA            NA                  GTX       NA
    R3    MGTXRXN0_115                  NA                 115   NA            NA                  GTX       NA
    A4    MGTXTXP3_116                  NA                 116   NA            NA                  GTX       NA
    B6    MGTXRXP3_116                  NA                 116   NA            NA                  GTX       NA
    A3    MGTXTXN3_116                  NA                 116   NA            NA                  GTX       NA
    B5    MGTXRXN3_116                  NA                 116   NA            NA                  GTX       NA
    B2    MGTXTXP2_116                  NA                 116   NA            NA                  GTX       NA
    C4    MGTXRXP2_116                  NA                 116   NA            NA                  GTX       NA
    B1    MGTXTXN2_116                  NA                 116   NA            NA                  GTX       NA
    D6    MGTREFCLK0P_116               NA                 116   NA            NA                  GTX       NA
    C3    MGTXRXN2_116                  NA                 116   NA            NA                  GTX       NA
    D5    MGTREFCLK0N_116               NA                 116   NA            NA                  GTX       NA
    F5    MGTREFCLK1N_116               NA                 116   NA            NA                  GTX       NA
    F6    MGTREFCLK1P_116               NA                 116   NA            NA                  GTX       NA
    D2    MGTXTXP1_116                  NA                 116   NA            NA                  GTX       NA
    E4    MGTXRXP1_116                  NA                 116   NA            NA                  GTX       NA
    D1    MGTXTXN1_116                  NA                 116   NA            NA                  GTX       NA
    E3    MGTXRXN1_116                  NA                 116   NA            NA                  GTX       NA
    F2    MGTXTXP0_116                  NA                 116   NA            NA                  GTX       NA
    G4    MGTXRXP0_116                  NA                 116   NA            NA                  GTX       NA
    F1    MGTXTXN0_116                  NA                 116   NA            NA                  GTX       NA
    G3    MGTXRXN0_116                  NA                 116   NA            NA                  GTX       NA
  );
END top;

ARCHITECTURE Behavioral OF top IS
  -- Components
  COMPONENT global_clock_reset
    PORT (
      SYS_CLK_P  : IN  std_logic;
      SYS_CLK_N  : IN  std_logic;
      FORCE_RST  : IN  std_logic;
      -- output
      GLOBAL_RST : OUT std_logic;
      SYS_CLK    : OUT std_logic;
      CLK_OUT1   : OUT std_logic;
      CLK_OUT2   : OUT std_logic;
      CLK_OUT3   : OUT std_logic;
      CLK_OUT4   : OUT std_logic
    );
  END COMPONENT;
  ---------------------------------------------< ten_gig_eth
  COMPONENT ten_gig_eth
    PORT (
      REFCLK_P             : IN  std_logic;  -- 156.25MHz for transceiver
      REFCLK_N             : IN  std_logic;
      RESET                : IN  std_logic;
      SFP_TX_P             : OUT std_logic;
      SFP_TX_N             : OUT std_logic;
      SFP_RX_P             : IN  std_logic;
      SFP_RX_N             : IN  std_logic;
      SFP_LOS              : IN  std_logic;  -- loss of receiver signal
      SFP_TX_DISABLE       : OUT std_logic;
      -- clk156 domain, clock generated by the core
      CLK156               : OUT std_logic;
      PCS_PMA_CORE_STATUS  : OUT std_logic_vector(7 DOWNTO 0);
      TX_STATISTICS_VECTOR : OUT std_logic_vector(25 DOWNTO 0);
      TX_STATISTICS_VALID  : OUT std_logic;
      RX_STATISTICS_VECTOR : OUT std_logic_vector(29 DOWNTO 0);
      RX_STATISTICS_VALID  : OUT std_logic;
      PAUSE_VAL            : IN  std_logic_vector(15 DOWNTO 0);
      PAUSE_REQ            : IN  std_logic;
      TX_IFG_DELAY         : IN  std_logic_vector(7 DOWNTO 0);
      -- emac control interface
      S_AXI_ACLK           : IN  std_logic;
      S_AXI_ARESETN        : IN  std_logic;
      S_AXI_AWADDR         : IN  std_logic_vector(10 DOWNTO 0);
      S_AXI_AWVALID        : IN  std_logic;
      S_AXI_AWREADY        : OUT std_logic;
      S_AXI_WDATA          : IN  std_logic_vector(31 DOWNTO 0);
      S_AXI_WVALID         : IN  std_logic;
      S_AXI_WREADY         : OUT std_logic;
      S_AXI_BRESP          : OUT std_logic_vector(1 DOWNTO 0);
      S_AXI_BVALID         : OUT std_logic;
      S_AXI_BREADY         : IN  std_logic;
      S_AXI_ARADDR         : IN  std_logic_vector(10 DOWNTO 0);
      S_AXI_ARVALID        : IN  std_logic;
      S_AXI_ARREADY        : OUT std_logic;
      S_AXI_RDATA          : OUT std_logic_vector(31 DOWNTO 0);
      S_AXI_RRESP          : OUT std_logic_vector(1 DOWNTO 0);
      S_AXI_RVALID         : OUT std_logic;
      S_AXI_RREADY         : IN  std_logic;
      -- tx_wr_clk domain
      TX_AXIS_FIFO_ARESETN : IN  std_logic;
      TX_AXIS_FIFO_ACLK    : IN  std_logic;
      TX_AXIS_FIFO_TDATA   : IN  std_logic_vector(63 DOWNTO 0);
      TX_AXIS_FIFO_TKEEP   : IN  std_logic_vector(7 DOWNTO 0);
      TX_AXIS_FIFO_TVALID  : IN  std_logic;
      TX_AXIS_FIFO_TLAST   : IN  std_logic;
      TX_AXIS_FIFO_TREADY  : OUT std_logic;
      -- rx_rd_clk domain
      RX_AXIS_FIFO_ARESETN : IN  std_logic;
      RX_AXIS_FIFO_ACLK    : IN  std_logic;
      RX_AXIS_FIFO_TDATA   : OUT std_logic_vector(63 DOWNTO 0);
      RX_AXIS_FIFO_TKEEP   : OUT std_logic_vector(7 DOWNTO 0);
      RX_AXIS_FIFO_TVALID  : OUT std_logic;
      RX_AXIS_FIFO_TLAST   : OUT std_logic;
      RX_AXIS_FIFO_TREADY  : IN  std_logic
    );
  END COMPONENT;
  COMPONENT ten_gig_eth_packet_gen
    PORT (
      RESET          : IN  std_logic;
      MEM_CLK        : IN  std_logic;
      MEM_WE         : IN  std_logic;   -- memory write enable
      MEM_ADDR       : IN  std_logic_vector(31 DOWNTO 0);
      MEM_D          : IN  std_logic_vector(31 DOWNTO 0);  -- memory data
      --
      TX_AXIS_ACLK   : IN  std_logic;
      TX_START       : IN  std_logic;
      TX_BYTES       : IN  std_logic_vector(15 DOWNTO 0);  -- number of bytes to send
      TX_AXIS_TDATA  : OUT std_logic_vector(63 DOWNTO 0);
      TX_AXIS_TKEEP  : OUT std_logic_vector(7 DOWNTO 0);
      TX_AXIS_TVALID : OUT std_logic;
      TX_AXIS_TLAST  : OUT std_logic;
      TX_AXIS_TREADY : IN  std_logic
    );
  END COMPONENT;
  COMPONENT ten_gig_eth_rx_parser
    PORT (
      RESET                : IN  std_logic;
      RX_AXIS_FIFO_ARESETN : OUT std_logic;
      -- Everything internal to this module is synchronous to this clock `ACLK'
      RX_AXIS_FIFO_ACLK    : IN  std_logic;
      RX_AXIS_FIFO_TDATA   : IN  std_logic_vector(63 DOWNTO 0);
      RX_AXIS_FIFO_TKEEP   : IN  std_logic_vector(7 DOWNTO 0);
      RX_AXIS_FIFO_TVALID  : IN  std_logic;
      RX_AXIS_FIFO_TLAST   : IN  std_logic;
      RX_AXIS_FIFO_TREADY  : OUT std_logic;
      -- Constants
      SRC_MAC              : IN  std_logic_vector(47 DOWNTO 0);
      SRC_IP               : IN  std_logic_vector(31 DOWNTO 0);
      SRC_PORT             : IN  std_logic_vector(15 DOWNTO 0);
      -- Command output fifo interface AFTER parsing the packet
      -- dstMAC(48) dstIP(32) dstPort(16) opcode(32)
      CMD_FIFO_Q           : OUT std_logic_vector(127 DOWNTO 0);
      CMD_FIFO_EMPTY       : OUT std_logic;
      CMD_FIFO_RDREQ       : IN  std_logic;
      CMD_FIFO_RDCLK       : IN  std_logic
    );
  END COMPONENT;
  ---------------------------------------------> ten_gig_eth
  ---------------------------------------------< gig_eth
  COMPONENT gig_eth
    PORT (
      -- asynchronous reset
      GLBL_RST             : IN    std_logic;
      -- clocks
      GTX_CLK              : IN    std_logic;  -- 125MHz
      REF_CLK              : IN    std_logic;  -- 200MHz for IODELAY
      -- PHY interface
      PHY_RESETN           : OUT   std_logic;
      -- RGMII Interface
      RGMII_TXD            : OUT   std_logic_vector(3 DOWNTO 0);
      RGMII_TX_CTL         : OUT   std_logic;
      RGMII_TXC            : OUT   std_logic;
      RGMII_RXD            : IN    std_logic_vector(3 DOWNTO 0);
      RGMII_RX_CTL         : IN    std_logic;
      RGMII_RXC            : IN    std_logic;
      -- MDIO Interface
      MDIO                 : INOUT std_logic;
      MDC                  : OUT   std_logic;
      -- TCP
      MAC_ADDR             : IN    std_logic_vector(47 DOWNTO 0);
      IPv4_ADDR            : IN    std_logic_vector(31 DOWNTO 0);
      IPv6_ADDR            : IN    std_logic_vector(127 DOWNTO 0);
      SUBNET_MASK          : IN    std_logic_vector(31 DOWNTO 0);
      GATEWAY_IP_ADDR      : IN    std_logic_vector(31 DOWNTO 0);
      TCP_CONNECTION_RESET : IN    std_logic;
      TX_TDATA             : IN    std_logic_vector(7 DOWNTO 0);
      TX_TVALID            : IN    std_logic;
      TX_TREADY            : OUT   std_logic;
      RX_TDATA             : OUT   std_logic_vector(7 DOWNTO 0);
      RX_TVALID            : OUT   std_logic;
      RX_TREADY            : IN    std_logic;
      -- FIFO
      TCP_USE_FIFO         : IN    std_logic;
      TX_FIFO_WRCLK        : IN    std_logic;
      TX_FIFO_Q            : IN    std_logic_vector(31 DOWNTO 0);
      TX_FIFO_WREN         : IN    std_logic;
      TX_FIFO_FULL         : OUT   std_logic;
      RX_FIFO_RDCLK        : IN    std_logic;
      RX_FIFO_Q            : OUT   std_logic_vector(31 DOWNTO 0);
      RX_FIFO_RDEN         : IN    std_logic;
      RX_FIFO_EMPTY        : OUT   std_logic
    );
  END COMPONENT;
  ---------------------------------------------> gig_eth
  ---------------------------------------------< UART/RS232
  COMPONENT control_interface
    PORT (
      RESET           : IN  std_logic;
      CLK             : IN  std_logic;    -- system clock
      -- From FPGA to PC
      FIFO_Q          : OUT std_logic_vector(35 DOWNTO 0);  -- interface fifo data output port
      FIFO_EMPTY      : OUT std_logic;    -- interface fifo "emtpy" signal
      FIFO_RDREQ      : IN  std_logic;    -- interface fifo read request
      FIFO_RDCLK      : IN  std_logic;    -- interface fifo read clock
      -- From PC to FPGA, FWFT
      CMD_FIFO_Q      : IN  std_logic_vector(35 DOWNTO 0);  -- interface command fifo data out port
      CMD_FIFO_EMPTY  : IN  std_logic;    -- interface command fifo "emtpy" signal
      CMD_FIFO_RDREQ  : OUT std_logic;    -- interface command fifo read request
      -- Digital I/O
      CONFIG_REG      : OUT std_logic_vector(511 DOWNTO 0); -- thirtytwo 16bit registers
      PULSE_REG       : OUT std_logic_vector(15 DOWNTO 0);  -- 16bit pulse register
      STATUS_REG      : IN  std_logic_vector(175 DOWNTO 0); -- eleven 16bit registers
      -- Memory interface
      MEM_WE          : OUT std_logic;    -- memory write enable
      MEM_ADDR        : OUT std_logic_vector(31 DOWNTO 0);
      MEM_DIN         : OUT std_logic_vector(31 DOWNTO 0);  -- memory data input
      MEM_DOUT        : IN  std_logic_vector(31 DOWNTO 0);  -- memory data output
      -- Data FIFO interface, FWFT
      DATA_FIFO_Q     : IN  std_logic_vector(31 DOWNTO 0);
      DATA_FIFO_EMPTY : IN  std_logic;
      DATA_FIFO_RDREQ : OUT std_logic;
      DATA_FIFO_RDCLK : OUT std_logic
    );
  END COMPONENT;
  ---------------------------------------------> UART/RS232
  ---------------------------------------------< SDRAM
  COMPONENT sdram_ddr3
    GENERIC (
      INDATA_WIDTH   : positive := 256;
      OUTDATA_WIDTH  : positive := 32;
      APP_ADDR_WIDTH : positive := 28;
      APP_DATA_WIDTH : positive := 512;
      APP_MASK_WIDTH : positive := 64;
      APP_ADDR_BURST : positive := 8
    );
    PORT (
      CLK                   : IN    std_logic;  -- system clock, must be the same as intended in MIG
      REFCLK                : IN    std_logic;  -- 200MHz for iodelay
      RESET                 : IN    std_logic;
      -- SDRAM_DDR3
      -- Inouts
      DDR3_DQ               : INOUT std_logic_vector(63 DOWNTO 0);
      DDR3_DQS_P            : INOUT std_logic_vector(7 DOWNTO 0);
      DDR3_DQS_N            : INOUT std_logic_vector(7 DOWNTO 0);
      -- Outputs
      DDR3_ADDR             : OUT   std_logic_vector(13 DOWNTO 0);
      DDR3_BA               : OUT   std_logic_vector(2 DOWNTO 0);
      DDR3_RAS_N            : OUT   std_logic;
      DDR3_CAS_N            : OUT   std_logic;
      DDR3_WE_N             : OUT   std_logic;
      DDR3_RESET_N          : OUT   std_logic;
      DDR3_CK_P             : OUT   std_logic_vector(0 DOWNTO 0);
      DDR3_CK_N             : OUT   std_logic_vector(0 DOWNTO 0);
      DDR3_CKE              : OUT   std_logic_vector(0 DOWNTO 0);
      DDR3_CS_N             : OUT   std_logic_vector(0 DOWNTO 0);
      DDR3_DM               : OUT   std_logic_vector(7 DOWNTO 0);
      DDR3_ODT              : OUT   std_logic_vector(0 DOWNTO 0);
      -- Status Outputs
      INIT_CALIB_COMPLETE   : OUT   std_logic;
      -- Internal data r/w interface
      UI_CLK                : OUT   std_logic;
      --
      CTRL_RESET            : IN    std_logic;
      WR_START              : IN    std_logic;
      WR_ADDR_BEGIN         : IN    std_logic_vector(APP_ADDR_WIDTH-1 DOWNTO 0);
      WR_STOP               : IN    std_logic;
      WR_WRAP_AROUND        : IN    std_logic;
      POST_TRIGGER          : IN    std_logic_vector(APP_ADDR_WIDTH-1 DOWNTO 0);
      WR_BUSY               : OUT   std_logic;
      WR_POINTER            : OUT   std_logic_vector(APP_ADDR_WIDTH-1 DOWNTO 0);
      TRIGGER_POINTER       : OUT   std_logic_vector(APP_ADDR_WIDTH-1 DOWNTO 0);
      WR_WRAPPED            : OUT   std_logic;
      RD_START              : IN    std_logic;
      RD_ADDR_BEGIN         : IN    std_logic_vector(APP_ADDR_WIDTH-1 DOWNTO 0);
      RD_ADDR_END           : IN    std_logic_vector(APP_ADDR_WIDTH-1 DOWNTO 0);
      RD_BUSY               : OUT   std_logic;
      --
      DATA_FIFO_RESET       : IN    std_logic;
      INDATA_FIFO_WRCLK     : IN    std_logic;
      INDATA_FIFO_Q         : IN    std_logic_vector(INDATA_WIDTH-1 DOWNTO 0);
      INDATA_FIFO_FULL      : OUT   std_logic;
      INDATA_FIFO_WREN      : IN    std_logic;
      --
      OUTDATA_FIFO_RDCLK    : IN    std_logic;
      OUTDATA_FIFO_Q        : OUT   std_logic_vector(OUTDATA_WIDTH-1 DOWNTO 0);
      OUTDATA_FIFO_EMPTY    : OUT   std_logic;
      OUTDATA_FIFO_RDEN     : IN    std_logic;
      --
      DBG_APP_ADDR          : OUT   std_logic_vector(APP_ADDR_WIDTH-1 DOWNTO 0);
      DBG_APP_EN            : OUT   std_logic;
      DBG_APP_RDY           : OUT   std_logic;
      DBG_APP_WDF_DATA      : OUT   std_logic_vector(APP_DATA_WIDTH-1 DOWNTO 0);
      DBG_APP_WDF_END       : OUT   std_logic;
      DBG_APP_WDF_WREN      : OUT   std_logic;
      DBG_APP_WDF_RDY       : OUT   std_logic;
      DBG_APP_RD_DATA       : OUT   std_logic_vector(APP_DATA_WIDTH-1 DOWNTO 0);
      DBG_APP_RD_DATA_VALID : OUT   std_logic
    );
  END COMPONENT;
  ---------------------------------------------> SDRAM
  ---------------------------------------------< I2C
  COMPONENT i2c_write_regmap
    GENERIC (
      REGMAP_FNAME        : string;
      INPUT_CLK_FREQENCY  : integer := 100_000_000;
      -- BUS CLK freqency should be divided by multiples of 4 from input frequency
      BUS_CLK_FREQUENCY   : integer := 100_000;
      START_DELAY_CYCLE   : integer := 100_000_000; -- ext_rst to happen # of clk cycles after START
      EXT_RST_WIDTH_CYCLE : integer := 1000;     -- pulse width of ext_rst in clk cycles
      EXT_RST_DELAY_CYCLE : integer := 100_000   -- 1st reg write to happen clk cycles after ext_rst
    );
    PORT (
      CLK       : IN  std_logic;        -- system clock 50Mhz
      RESET     : IN  std_logic;        -- active high reset
      START     : IN  std_logic;  -- rising edge triggers r/w; synchronous to CLK
      EXT_RSTn  : OUT std_logic;        -- active low for resetting the slave
      BUSY      : OUT std_logic;        -- indicates transaction in progress
      ACK_ERROR : OUT std_logic;        -- i2c has unexpected ack
      SDA_in    : IN  std_logic;        -- serial data input from i2c bus
      SDA_out   : OUT std_logic;        -- serial data output to i2c bus
      SDA_t     : OUT std_logic;  -- serial data direction to/from i2c bus, '1' is read-in
      SCL       : OUT std_logic         -- serial clock output to i2c bus
    );
  END COMPONENT;
  ---------------------------------------------> I2C
  ---------------------------------------------< debug : ILA and VIO (`Chipscope')
  COMPONENT dbg_ila
    PORT (
      CLK    : IN std_logic;
      PROBE0 : IN std_logic_vector(63 DOWNTO 0);
      PROBE1 : IN std_logic_vector(79 DOWNTO 0);
      PROBE2 : IN std_logic_vector(79 DOWNTO 0);
      PROBE3 : IN std_logic_vector(2047 DOWNTO 0)
    );
  END COMPONENT;
  COMPONENT dbg_ila1
    PORT (
      CLK    : IN std_logic;
      PROBE0 : IN std_logic_vector(15 DOWNTO 0);
      PROBE1 : IN std_logic_vector(15 DOWNTO 0)
    );
  END COMPONENT;
  COMPONENT dbg_vio
    PORT (
      CLK        : IN  std_logic;
      PROBE_IN0  : IN  std_logic_vector(63 DOWNTO 0);
      PROBE_IN1  : IN  std_logic_vector(63 DOWNTO 0);
      PROBE_IN2  : IN  std_logic_vector(63 DOWNTO 0);
      PROBE_IN3  : IN  std_logic_vector(63 DOWNTO 0);
      PROBE_IN4  : IN  std_logic_vector(63 DOWNTO 0);
      PROBE_IN5  : IN  std_logic_vector(63 DOWNTO 0);
      PROBE_IN6  : IN  std_logic_vector(63 DOWNTO 0);
      PROBE_IN7  : IN  std_logic_vector(63 DOWNTO 0);
      PROBE_IN8  : IN  std_logic_vector(35 DOWNTO 0);
      PROBE_OUT0 : OUT std_logic_vector(63 DOWNTO 0)
    );
  END COMPONENT;
  ---------------------------------------------> debug : ILA and VIO (`Chipscope')

  -- Signals
  SIGNAL reset                             : std_logic;
  SIGNAL sys_clk                           : std_logic;
  SIGNAL clk_50MHz                         : std_logic;
  SIGNAL clk_100MHz                        : std_logic;
  SIGNAL clk_125MHz                        : std_logic;
  SIGNAL clk_200MHz                        : std_logic;
  SIGNAL clk_250MHz                        : std_logic;
  SIGNAL clk156                            : std_logic;
  SIGNAL clk_sgmii_i                       : std_logic;
  SIGNAL clk_sgmii                         : std_logic;
  SIGNAL clk_si5324_i                      : std_logic;
  SIGNAL clk_si5324                        : std_logic;
  ---------------------------------------------< UART/RS232
  SIGNAL uart_rx_data                      : std_logic_vector(7 DOWNTO 0);
  SIGNAL uart_rx_rdy                       : std_logic;
  SIGNAL control_clk                       : std_logic;
  SIGNAL control_fifo_q                    : std_logic_vector(35 DOWNTO 0);
  SIGNAL control_fifo_rdreq                : std_logic;
  SIGNAL control_fifo_empty                : std_logic;
  SIGNAL control_fifo_rdclk                : std_logic;
  SIGNAL cmd_fifo_q                        : std_logic_vector(35 DOWNTO 0);
  SIGNAL cmd_fifo_empty                    : std_logic;
  SIGNAL cmd_fifo_rdreq                    : std_logic;
  -- thirtytwo 16bit registers
  SIGNAL config_reg                        : std_logic_vector(511 DOWNTO 0);
  -- 16bit pulse register
  SIGNAL pulse_reg                         : std_logic_vector(15 DOWNTO 0);
  -- eleven 16bit registers
  SIGNAL status_reg                        : std_logic_vector(175 DOWNTO 0) := (OTHERS => '0');
  SIGNAL control_mem_we                    : std_logic;
  SIGNAL control_mem_addr                  : std_logic_vector(31 DOWNTO 0);
  SIGNAL control_mem_din                   : std_logic_vector(31 DOWNTO 0);
  ---------------------------------------------> UART/RS232
  ---------------------------------------------< ten_gig_eth
  SIGNAL sfp_tx_disable_i                  : std_logic;
  SIGNAL sPcs_pma_core_status              : std_logic_vector(7 DOWNTO 0);
  SIGNAL sEmac_status_vector               : std_logic_vector(1 DOWNTO 0);
  SIGNAL sTx_axis_fifo_aresetn             : std_logic;
  SIGNAL sTx_axis_fifo_aclk                : std_logic;
  SIGNAL sTx_axis_fifo_tdata               : std_logic_vector(63 DOWNTO 0);
  SIGNAL sTx_axis_fifo_tkeep               : std_logic_vector(7 DOWNTO 0);
  SIGNAL sTx_axis_fifo_tvalid              : std_logic;
  SIGNAL sTx_axis_fifo_tlast               : std_logic;
  SIGNAL sTx_axis_fifo_tready              : std_logic;
  SIGNAL sRx_axis_fifo_aresetn             : std_logic;
  SIGNAL sRx_axis_fifo_aclk                : std_logic;
  SIGNAL sRx_axis_fifo_tdata               : std_logic_vector(63 DOWNTO 0);
  SIGNAL sRx_axis_fifo_tkeep               : std_logic_vector(7 DOWNTO 0);
  SIGNAL sRx_axis_fifo_tvalid              : std_logic;
  SIGNAL sRx_axis_fifo_tlast               : std_logic;
  SIGNAL sRx_axis_fifo_tready              : std_logic;
  -- control interface
  SIGNAL s_axi_aclk                        : std_logic;
  SIGNAL s_axi_aresetn                     : std_logic;
  SIGNAL s_axi_awaddr                      : std_logic_vector(10 DOWNTO 0);
  SIGNAL s_axi_awvalid                     : std_logic;
  SIGNAL s_axi_awready                     : std_logic;
  SIGNAL s_axi_wdata                       : std_logic_vector(31 DOWNTO 0);
  SIGNAL s_axi_wvalid                      : std_logic;
  SIGNAL s_axi_wready                      : std_logic;
  SIGNAL s_axi_bresp                       : std_logic_vector(1 DOWNTO 0);
  SIGNAL s_axi_bvalid                      : std_logic;
  SIGNAL s_axi_bready                      : std_logic;
  SIGNAL s_axi_araddr                      : std_logic_vector(10 DOWNTO 0);
  SIGNAL s_axi_arvalid                     : std_logic;
  SIGNAL s_axi_arready                     : std_logic;
  SIGNAL s_axi_rdata                       : std_logic_vector(31 DOWNTO 0);
  SIGNAL s_axi_rresp                       : std_logic_vector(1 DOWNTO 0);
  SIGNAL s_axi_rvalid                      : std_logic;
  SIGNAL s_axi_rready                      : std_logic;
  -- packets
  SIGNAL ten_gig_eth_tx_start              : std_logic;
  SIGNAL tge_cmd_fifo_q                    : std_logic_vector(127 DOWNTO 0);
  SIGNAL tge_cmd_fifo_empty                : std_logic;
  SIGNAL tge_cmd_fifo_rdreq                : std_logic;
  ---------------------------------------------> ten_gig_eth
  SIGNAL usr_data_output                   : std_logic_vector (7 DOWNTO 0);
  ---------------------------------------------< gig_eth
  SIGNAL gig_eth_mac_addr                  : std_logic_vector(47 DOWNTO 0);
  SIGNAL gig_eth_ipv4_addr                 : std_logic_vector(31 DOWNTO 0);
  SIGNAL gig_eth_subnet_mask               : std_logic_vector(31 DOWNTO 0);
  SIGNAL gig_eth_gateway_ip_addr           : std_logic_vector(31 DOWNTO 0);
  SIGNAL gig_eth_tx_tdata                  : std_logic_vector(7 DOWNTO 0);
  SIGNAL gig_eth_tx_tvalid                 : std_logic;
  SIGNAL gig_eth_tx_tready                 : std_logic;
  SIGNAL gig_eth_rx_tdata                  : std_logic_vector(7 DOWNTO 0);
  SIGNAL gig_eth_rx_tvalid                 : std_logic;
  SIGNAL gig_eth_rx_tready                 : std_logic;
  SIGNAL gig_eth_tcp_use_fifo              : std_logic;
  SIGNAL gig_eth_tx_fifo_wrclk             : std_logic;
  SIGNAL gig_eth_tx_fifo_q                 : std_logic_vector(31 DOWNTO 0);
  SIGNAL gig_eth_tx_fifo_wren              : std_logic;
  SIGNAL gig_eth_tx_fifo_full              : std_logic;
  SIGNAL gig_eth_rx_fifo_rdclk             : std_logic;
  SIGNAL gig_eth_rx_fifo_q                 : std_logic_vector(31 DOWNTO 0);
  SIGNAL gig_eth_rx_fifo_rden              : std_logic;
  SIGNAL gig_eth_rx_fifo_empty             : std_logic;
  ---------------------------------------------> gig_eth
  ---------------------------------------------< SDRAM
  SIGNAL sdram_app_addr                    : std_logic_vector(28-1 DOWNTO 0);
  SIGNAL sdram_app_en                      : std_logic;
  SIGNAL sdram_app_rdy                     : std_logic;
  SIGNAL sdram_app_wdf_data                : std_logic_vector(512-1 DOWNTO 0);
  SIGNAL sdram_app_wdf_end                 : std_logic;
  SIGNAL sdram_app_wdf_wren                : std_logic;
  SIGNAL sdram_app_wdf_rdy                 : std_logic;
  SIGNAL sdram_app_rd_data                 : std_logic_vector(512-1 DOWNTO 0);
  SIGNAL sdram_app_rd_data_valid           : std_logic;
  ---------------------------------------------> SDRAM
  ---------------------------------------------< IDATA
  SIGNAL TRIG_OUT_0                        : std_logic;
  SIGNAL idata_cmd_out                     : std_logic_vector(63 DOWNTO 0);
  SIGNAL idata_cmd_out_val                 : std_logic;
  SIGNAL idata_cmd_in                      : std_logic_vector(63 DOWNTO 0);
  SIGNAL idata_cmd_in_val                  : std_logic;
  SIGNAL idata_adc_data_clk                : std_logic;
  SIGNAL idata_adc_refout_clkdiv           : std_logic;
  SIGNAL idata_adc_data0                   : std_logic_vector(15 DOWNTO 0);
  SIGNAL idata_adc_data1                   : std_logic_vector(15 DOWNTO 0);
  SIGNAL idata_adc_data2                   : std_logic_vector(15 DOWNTO 0);
  SIGNAL idata_adc_data3                   : std_logic_vector(15 DOWNTO 0);
  SIGNAL idata_adc_data4                   : std_logic_vector(15 DOWNTO 0);
  SIGNAL idata_adc_data5                   : std_logic_vector(15 DOWNTO 0);
  SIGNAL idata_adc_data6                   : std_logic_vector(15 DOWNTO 0);
  SIGNAL idata_adc_data7                   : std_logic_vector(15 DOWNTO 0);
  SIGNAL idata_adc_data8                   : std_logic_vector(15 DOWNTO 0);
  SIGNAL idata_adc_data9                   : std_logic_vector(15 DOWNTO 0);
  SIGNAL idata_adc_data10                  : std_logic_vector(15 DOWNTO 0);
  SIGNAL idata_adc_data11                  : std_logic_vector(15 DOWNTO 0);
  SIGNAL idata_data_fifo_reset             : std_logic;
  SIGNAL idata_data_fifo_rdclk             : std_logic;
  SIGNAL idata_data_fifo_din               : std_logic_vector(255 DOWNTO 0);
  SIGNAL idata_channel_avg_outdata_q       : std_logic_vector(255 DOWNTO 0);
  SIGNAL idata_channel_avg_outvalid        : std_logic;
  SIGNAL idata_data_fifo_wren              : std_logic;
  SIGNAL idata_data_fifo_rden              : std_logic;
  SIGNAL idata_data_fifo_dout              : std_logic_vector(31 DOWNTO 0);
  SIGNAL idata_data_fifo_full              : std_logic;
  SIGNAL idata_data_fifo_empty             : std_logic;
  SIGNAL idata_idata_fifo_q                : std_logic_vector(255 DOWNTO 0);
  SIGNAL idata_idata_fifo_wren             : std_logic;
  SIGNAL idata_idata_fifo_rden             : std_logic;
  SIGNAL idata_idata_fifo_full             : std_logic;
  SIGNAL idata_idata_fifo_empty            : std_logic;
  SIGNAL idata_trig_allow                  : std_logic;
  SIGNAL idata_trig_in                     : std_logic;
  SIGNAL idata_trig_synced                 : std_logic;
  SIGNAL idata_data_wr_start               : std_logic;
  SIGNAL idata_data_wr_busy                : std_logic;
  SIGNAL idata_data_wr_wrapped             : std_logic;
  ---------------------------------------------> IDATA
  ---------------------------------------------< I2C
  SIGNAL i2c_sda_out                       : std_logic;
  SIGNAL i2c_sda_in                        : std_logic;
  SIGNAL i2c_sda_t                         : std_logic;
  SIGNAL i2c_scl_out                       : std_logic;
  ---------------------------------------------> I2C
  ---------------------------------------------< debug
  SIGNAL dbg_ila_probe0                           : std_logic_vector (63 DOWNTO 0);
  SIGNAL dbg_ila_probe1                           : std_logic_vector (79 DOWNTO 0);
  SIGNAL dbg_ila_probe2                           : std_logic_vector (79 DOWNTO 0);
  SIGNAL dbg_ila_probe3                           : std_logic_vector (2047 DOWNTO 0);
  SIGNAL dbg_vio_probe_out0                       : std_logic_vector (63 DOWNTO 0);
  SIGNAL dbg_ila1_probe0                          : std_logic_vector (15 DOWNTO 0);
  SIGNAL dbg_ila1_probe1                          : std_logic_vector (15 DOWNTO 0);
  ATTRIBUTE mark_debug                            : string;
  ATTRIBUTE keep                                  : string;
  ATTRIBUTE mark_debug OF USB_TX                  : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF uart_rx_data            : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF uart_rx_rdy             : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF cmd_fifo_q              : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF cmd_fifo_empty          : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF cmd_fifo_rdreq          : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF config_reg              : SIGNAL IS "true";
--ATTRIBUTE mark_debug OF status_reg              : SIGNAL IS "true";
--ATTRIBUTE mark_debug OF pulse_reg               : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF control_mem_we          : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF control_mem_addr        : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF control_mem_din         : SIGNAL IS "true";
  --
  ATTRIBUTE mark_debug OF sPcs_pma_core_status    : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF sEmac_status_vector     : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF sTx_axis_fifo_aresetn   : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF sTx_axis_fifo_aclk      : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF sTx_axis_fifo_tdata     : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF sTx_axis_fifo_tkeep     : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF sTx_axis_fifo_tvalid    : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF sTx_axis_fifo_tlast     : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF sTx_axis_fifo_tready    : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF sRx_axis_fifo_aresetn   : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF sRx_axis_fifo_aclk      : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF sRx_axis_fifo_tdata     : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF sRx_axis_fifo_tkeep     : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF sRx_axis_fifo_tvalid    : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF sRx_axis_fifo_tlast     : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF sRx_axis_fifo_tready    : SIGNAL IS "true";
  --ATTRIBUTE mark_debug OF ten_gig_eth_tx_start    : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF tge_cmd_fifo_q          : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF tge_cmd_fifo_empty      : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF tge_cmd_fifo_rdreq      : SIGNAL IS "true";
  --
  ATTRIBUTE mark_debug OF gig_eth_tx_tdata        : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF gig_eth_tx_tvalid       : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF gig_eth_tx_tready       : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF gig_eth_rx_tdata        : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF gig_eth_rx_tvalid       : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF gig_eth_rx_tready       : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF gig_eth_tx_fifo_q       : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF gig_eth_rx_fifo_q       : SIGNAL IS "true";
  --
  ATTRIBUTE mark_debug OF sdram_app_addr          : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF sdram_app_en            : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF sdram_app_rdy           : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF sdram_app_wdf_data      : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF sdram_app_wdf_end       : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF sdram_app_wdf_wren      : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF sdram_app_wdf_rdy       : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF sdram_app_rd_data       : SIGNAL IS "true";
  ATTRIBUTE mark_debug OF sdram_app_rd_data_valid : SIGNAL IS "true";
  ---------------------------------------------> debug

BEGIN
  ---------------------------------------------< Clock
  global_clock_reset_inst : global_clock_reset
    PORT MAP (
      SYS_CLK_P  => SYS_CLK_P,
      SYS_CLK_N  => SYS_CLK_N,
      FORCE_RST  => SYS_RST,
      -- output
      GLOBAL_RST => reset,
      SYS_CLK    => sys_clk,
      CLK_OUT1   => clk_50MHz,
      CLK_OUT2   => clk_100MHz,
      CLK_OUT3   => OPEN,
      CLK_OUT4   => clk_250MHz
    );

  -- gtx/gth reference clock can be used as general purpose clock this way
  sgmiiclk_ibufds_inst : IBUFDS_GTE2
    PORT MAP (
      O     => clk_sgmii_i,
      ODIV2 => OPEN,
      CEB   => '0',
      I     => SGMIICLK_Q0_P,
      IB    => SGMIICLK_Q0_N
    );
  sgmiiclk_bufg_inst : BUFG
    PORT MAP (
      I => clk_sgmii_i,
      O => clk_sgmii
    );
  clk_125MHz <= clk_sgmii;
  ---------------------------------------------> Clock
  ---------------------------------------------< debug : ILA and VIO (`Chipscope')
  dbg_cores : IF ENABLE_DEBUG GENERATE
    dbg_ila_inst : dbg_ila
      PORT MAP (
        CLK    => sys_clk,
        PROBE0 => dbg_ila_probe0,
        PROBE1 => dbg_ila_probe1,
        PROBE2 => dbg_ila_probe2,
        PROBE3 => dbg_ila_probe3
      );
    dbg_vio_inst : dbg_vio
      PORT MAP (
        CLK        => sys_clk,
        PROBE_IN0  => config_reg(64*1-1 DOWNTO 64*0),
        PROBE_IN1  => config_reg(64*2-1 DOWNTO 64*1),
        PROBE_IN2  => config_reg(64*3-1 DOWNTO 64*2),
        PROBE_IN3  => config_reg(64*4-1 DOWNTO 64*3),
        PROBE_IN4  => config_reg(64*5-1 DOWNTO 64*4),
        PROBE_IN5  => config_reg(64*6-1 DOWNTO 64*5),
        PROBE_IN6  => config_reg(64*7-1 DOWNTO 64*6),
        PROBE_IN7  => x"00000000000000" & sPcs_pma_core_status, -- config_reg(64*8-1 DOWNTO 64*7),
        PROBE_IN8  => cmd_fifo_q,
        PROBE_OUT0 => dbg_vio_probe_out0
      );
    --dbg_ila1_inst : dbg_ila1
    --  PORT MAP (
    --    CLK    => sys_clk,
    --    PROBE0 => dbg_ila1_probe0,
    --    PROBE1 => dbg_ila1_probe1
    --  );
  END GENERATE dbg_cores;
  ---------------------------------------------> debug : ILA and VIO (`Chipscope')
  ---------------------------------------------< UART/RS232
  uart_cores : IF false GENERATE
    uartio_inst : uartio
      GENERIC MAP (
        -- tick repetition frequency is (input freq) / (2**COUNTER_WIDTH / DIVISOR)
        COUNTER_WIDTH => 16,
        DIVISOR       => 1208*2
      )
      PORT MAP (
        CLK     => clk_50MHz,
        RESET   => reset,
        RX_DATA => uart_rx_data,
        RX_RDY  => uart_rx_rdy,
        TX_DATA => "0000" & DIPSw4Bit,
        TX_EN   => '1',
        TX_RDY  => dbg_ila_probe0(2),
        -- serial lines
        RX_PIN  => USB_TX,                -- notice the pin swap
        TX_PIN  => USB_RX
      );

    --dbg_ila1_probe0(7 DOWNTO 0)  <= uart_rx_data;
    --dbg_ila1_probe0(8)           <= uart_rx_rdy;
    --dbg_ila1_probe0(9)           <= USB_TX;

    -- dbg_ila_probe0(63 DOWNTO 32) <= cmd_fifo_q(31 DOWNTO 0);
    dbg_ila_probe0(31)           <= cmd_fifo_empty;
    dbg_ila_probe0(30)           <= cmd_fifo_rdreq;

    byte2cmd_inst : byte2cmd
      PORT MAP (
        CLK            => clk_50MHz,
        RESET          => reset,
        -- byte in
        RX_DATA        => uart_rx_data,
        RX_RDY         => uart_rx_rdy,
        -- cmd out
        CMD_FIFO_Q     => OPEN,-- cmd_fifo_q,
        CMD_FIFO_EMPTY => OPEN,-- cmd_fifo_empty,
        CMD_FIFO_RDCLK => control_clk,
        CMD_FIFO_RDREQ => '0'  -- cmd_fifo_rdreq
      );
  END GENERATE uart_cores;

  control_clk <= clk_100MHz;
  control_interface_inst : control_interface
    PORT MAP (
      RESET => reset,
      CLK   => control_clk,
      -- From FPGA to PC
      FIFO_Q          => control_fifo_q,
      FIFO_EMPTY      => control_fifo_empty,
      FIFO_RDREQ      => control_fifo_rdreq,
      FIFO_RDCLK      => control_fifo_rdclk,
      -- From PC to FPGA, FWFT
      CMD_FIFO_Q      => cmd_fifo_q,
      CMD_FIFO_EMPTY  => cmd_fifo_empty,
      CMD_FIFO_RDREQ  => cmd_fifo_rdreq,
      -- Digital I/O
      CONFIG_REG      => config_reg,
      PULSE_REG       => pulse_reg,
      STATUS_REG      => status_reg,
      -- Memory interface
      MEM_WE          => control_mem_we,
      MEM_ADDR        => control_mem_addr,
      MEM_DIN         => control_mem_din,
      MEM_DOUT        => (OTHERS => '0'),
      -- Data FIFO interface, FWFT
      DATA_FIFO_Q     => idata_data_fifo_dout,
      DATA_FIFO_EMPTY => idata_data_fifo_empty,
      DATA_FIFO_RDREQ => idata_data_fifo_rden,
      DATA_FIFO_RDCLK => idata_data_fifo_rdclk
    );
  dbg_ila_probe0(18 DOWNTO 3) <= pulse_reg;
  ---------------------------------------------> UART/RS232
  ---------------------------------------------< ten_gig_eth
  ten_gig_eth_cores : IF ENABLE_TEN_GIG_ETH GENERATE
    ten_gig_eth_inst : ten_gig_eth
      PORT MAP (
        REFCLK_P             => USER_CLK_P,  -- 156.25MHz for transceiver
        REFCLK_N             => USER_CLK_N,
        RESET                => reset,
        SFP_TX_P             => SFP_TX_P,
        SFP_TX_N             => SFP_TX_N,
        SFP_RX_P             => SFP_RX_P,
        SFP_RX_N             => SFP_RX_N,
        SFP_LOS              => SFP_LOS_LS,  -- loss of receiver signal
        SFP_TX_DISABLE       => sfp_tx_disable_i,
        -- clk156 domain, clock generated by the core
        CLK156               => clk156,
        PCS_PMA_CORE_STATUS  => sPcs_pma_core_status,
        TX_STATISTICS_VECTOR => OPEN,
        TX_STATISTICS_VALID  => OPEN,
        RX_STATISTICS_VECTOR => OPEN,
        RX_STATISTICS_VALID  => OPEN,
        PAUSE_VAL            => (OTHERS => '0'),
        PAUSE_REQ            => '0',
        TX_IFG_DELAY         => x"ff",
        -- emac control interface
        S_AXI_ACLK           => s_axi_aclk,
        S_AXI_ARESETN        => s_axi_aresetn,
        S_AXI_AWADDR         => s_axi_awaddr,
        S_AXI_AWVALID        => s_axi_awvalid,
        S_AXI_AWREADY        => s_axi_awready,
        S_AXI_WDATA          => s_axi_wdata,
        S_AXI_WVALID         => s_axi_wvalid,
        S_AXI_WREADY         => s_axi_wready,
        S_AXI_BRESP          => s_axi_bresp,
        S_AXI_BVALID         => s_axi_bvalid,
        S_AXI_BREADY         => s_axi_bready,
        S_AXI_ARADDR         => s_axi_araddr,
        S_AXI_ARVALID        => s_axi_arvalid,
        S_AXI_ARREADY        => s_axi_arready,
        S_AXI_RDATA          => s_axi_rdata,
        S_AXI_RRESP          => s_axi_rresp,
        S_AXI_RVALID         => s_axi_rvalid,
        S_AXI_RREADY         => s_axi_rready,
        -- tx_wr_clk domain
        TX_AXIS_FIFO_ARESETN => sTx_axis_fifo_aresetn,
        Tx_AXIS_FIFO_ACLK    => sTx_axis_fifo_aclk,
        TX_AXIS_FIFO_TDATA   => sTx_axis_fifo_tdata,
        TX_AXIS_FIFO_TKEEP   => sTx_axis_fifo_tkeep,
        TX_AXIS_FIFO_TVALID  => sTx_axis_fifo_tvalid,
        TX_AXIS_FIFO_TLAST   => sTx_axis_fifo_tlast,
        TX_AXIS_FIFO_TREADY  => sTx_axis_fifo_tready,
        -- rx_rd_clk domain
        RX_AXIS_FIFO_ARESETN => sRx_axis_fifo_aresetn,
        RX_AXIS_FIFO_ACLK    => sRx_axis_fifo_aclk,
        RX_AXIS_FIFO_TDATA   => sRx_axis_fifo_tdata,
        RX_AXIS_FIFO_TKEEP   => sRx_axis_fifo_tkeep,
        RX_AXIS_FIFO_TVALID  => sRx_axis_fifo_tvalid,
        RX_AXIS_FIFO_TLAST   => sRx_axis_fifo_tlast,
        RX_AXIS_FIFO_TREADY  => sRx_axis_fifo_tready
      );

    SFP_TX_DISABLE_N   <= NOT sfp_tx_disable_i;
    LED8Bit(7)         <= sPcs_pma_core_status(0);
    LED8Bit(6)         <= NOT sfp_tx_disable_i;
    LED8Bit(5)         <= NOT SFP_LOS_LS;
    s_axi_aclk         <= clk_50MHz;
    sTx_axis_fifo_aclk <= clk_200MHz;
    sRx_axis_fifo_aclk <= sTx_axis_fifo_aclk;

    s_axi_aresetn         <= '1';
    sTx_axis_fifo_aresetn <= '1';
    -- sRx_axis_fifo_aresetn <= '1';

    ten_gig_eth_packet_gen_inst : ten_gig_eth_packet_gen
      PORT MAP (
        RESET          => reset,
        MEM_CLK        => control_clk,
        MEM_WE         => control_mem_we,
        MEM_ADDR       => control_mem_addr,
        MEM_D          => control_mem_din,
        --
        TX_AXIS_ACLK   => sTx_axis_fifo_aclk,
        TX_START       => ten_gig_eth_tx_start,
        TX_BYTES       => config_reg(15 DOWNTO 0),
        TX_AXIS_TDATA  => OPEN, -- sTx_axis_fifo_tdata,
        TX_AXIS_TKEEP  => sTx_axis_fifo_tkeep,
        TX_AXIS_TVALID => sTx_axis_fifo_tvalid,
        TX_AXIS_TLAST  => sTx_axis_fifo_tlast,
        TX_AXIS_TREADY => sTx_axis_fifo_tready
      );

    ten_gig_eth_rx_parser_inst : ten_gig_eth_rx_parser
      PORT MAP (
        RESET                => reset,
        RX_AXIS_FIFO_ARESETN => sRx_axis_fifo_aresetn,
        -- Everything internal to this module is synchronous to this clock `ACLK'
        RX_AXIS_FIFO_ACLK    => sRx_axis_fifo_aclk,
        RX_AXIS_FIFO_TDATA   => sRx_axis_fifo_tdata,
        RX_AXIS_FIFO_TKEEP   => sRx_axis_fifo_tkeep,
        RX_AXIS_FIFO_TVALID  => sRx_axis_fifo_tvalid,
        RX_AXIS_FIFO_TLAST   => sRx_axis_fifo_tlast,
        RX_AXIS_FIFO_TREADY  => sRx_axis_fifo_tready,
        -- Constants
        SRC_MAC              => x"000a3502a759",
        SRC_IP               => x"c0a80302",
        SRC_PORT             => x"ea62",
        -- Command output fifo interface AFTER parsing the packet
        -- dstMAC(48) dstIP(32) dstPort(16) opcode(32)
        CMD_FIFO_Q           => tge_cmd_fifo_q,
        CMD_FIFO_EMPTY       => tge_cmd_fifo_empty,
        CMD_FIFO_RDREQ       => '1',
        CMD_FIFO_RDCLK       => clk_200MHz
      );

    ten_gig_eth_tx_start <= pulse_reg(0);

    dbg_ila_probe0(0) <= clk156;
    dbg_ila_probe0(1) <= ten_gig_eth_tx_start;

    dbg_ila_probe1(79 DOWNTO 16) <= sTx_axis_fifo_tdata;
    dbg_ila_probe1(15 DOWNTO 8)  <= sTx_axis_fifo_tkeep;
    dbg_ila_probe1(7)            <= sTx_axis_fifo_tvalid;
    dbg_ila_probe1(6)            <= sTx_axis_fifo_tlast;
    dbg_ila_probe1(5)            <= sTx_axis_fifo_tready;
    --dbg_ila_probe2(79 DOWNTO 16) <= sRx_axis_fifo_tdata;
    --dbg_ila_probe2(79 DOWNTO 48) <= control_mem_addr;
    --dbg_ila_probe2(47 DOWNTO 16) <= control_mem_din;
    --dbg_ila_probe2(15 DOWNTO 8)  <= sRx_axis_fifo_tkeep;
    dbg_ila_probe2(7)            <= sRx_axis_fifo_tvalid;
    dbg_ila_probe2(6)            <= sRx_axis_fifo_tlast;
    dbg_ila_probe2(5)            <= sRx_axis_fifo_tready;
    dbg_ila_probe2(4)            <= control_mem_we;
    --
    --dbg_ila_probe3(127 DOWNTO 0) <= tge_cmd_fifo_q;
    --dbg_ila_probe3(128)          <= tge_cmd_fifo_empty;
  END GENERATE ten_gig_eth_cores;
  ---------------------------------------------> ten_gig_eth
  ---------------------------------------------< gig_eth
  gig_eth_cores : IF ENABLE_GIG_ETH GENERATE
    gig_eth_mac_addr(gig_eth_mac_addr'length-1 DOWNTO 4)   <= x"000a3502a75";
    gig_eth_mac_addr(3 DOWNTO 0)                           <= DIPSw4Bit;
    gig_eth_ipv4_addr(gig_eth_ipv4_addr'length-1 DOWNTO 4) <= x"c0a8020";
    gig_eth_ipv4_addr(3 DOWNTO 0)                          <= DIPSw4Bit;
    gig_eth_subnet_mask                                    <= x"ffffff00";
    gig_eth_gateway_ip_addr                                <= x"c0a80201";
    gig_eth_inst : gig_eth
      PORT MAP (
        -- asynchronous reset
        GLBL_RST             => reset,
        -- clocks
        GTX_CLK              => clk_125MHz,
        REF_CLK              => sys_clk, -- 200MHz for IODELAY
        -- PHY interface
        PHY_RESETN           => PHY_RESET_N,
        -- RGMII Interface
        RGMII_TXD            => RGMII_TXD,
        RGMII_TX_CTL         => RGMII_TX_CTL,
        RGMII_TXC            => RGMII_TXC,
        RGMII_RXD            => RGMII_RXD,
        RGMII_RX_CTL         => RGMII_RX_CTL,
        RGMII_RXC            => RGMII_RXC,
        -- MDIO Interface
        MDIO                 => MDIO,
        MDC                  => MDC,
        -- TCP
        MAC_ADDR             => gig_eth_mac_addr,
        IPv4_ADDR            => gig_eth_ipv4_addr,
        IPv6_ADDR            => (OTHERS => '0'),
        SUBNET_MASK          => gig_eth_subnet_mask,
        GATEWAY_IP_ADDR      => gig_eth_gateway_ip_addr,
        TCP_CONNECTION_RESET => '0',
        TX_TDATA             => gig_eth_tx_tdata,
        TX_TVALID            => gig_eth_tx_tvalid,
        TX_TREADY            => gig_eth_tx_tready,
        RX_TDATA             => gig_eth_rx_tdata,
        RX_TVALID            => gig_eth_rx_tvalid,
        RX_TREADY            => gig_eth_rx_tready,
        -- FIFO
        TCP_USE_FIFO         => gig_eth_tcp_use_fifo,
        TX_FIFO_WRCLK        => gig_eth_tx_fifo_wrclk,
        TX_FIFO_Q            => gig_eth_tx_fifo_q,
        TX_FIFO_WREN         => gig_eth_tx_fifo_wren,
        TX_FIFO_FULL         => gig_eth_tx_fifo_full,
        RX_FIFO_RDCLK        => gig_eth_rx_fifo_rdclk,
        RX_FIFO_Q            => gig_eth_rx_fifo_q,
        RX_FIFO_RDEN         => gig_eth_rx_fifo_rden,
        RX_FIFO_EMPTY        => gig_eth_rx_fifo_empty
      );
    dbg_ila_probe0(26 DOWNTO 19) <= gig_eth_rx_tdata;
    dbg_ila_probe0(27)           <= gig_eth_rx_tvalid;
    dbg_ila_probe0(28)           <= gig_eth_rx_tready;

    -- loopback
    --gig_eth_tx_tdata  <= gig_eth_rx_tdata;
    --gig_eth_tx_tvalid <= gig_eth_rx_tvalid;
    --gig_eth_rx_tready <= gig_eth_tx_tready;

    -- receive to cmd_fifo
    gig_eth_tcp_use_fifo         <= '1';
    gig_eth_rx_fifo_rdclk        <= control_clk;
    cmd_fifo_q(31 DOWNTO 0)      <= gig_eth_rx_fifo_q;
    dbg_ila_probe0(63 DOWNTO 32) <= gig_eth_rx_fifo_q;
    cmd_fifo_empty               <= gig_eth_rx_fifo_empty;
    gig_eth_rx_fifo_rden         <= cmd_fifo_rdreq;

    -- send control_fifo data through gig_eth_tx_fifo
    gig_eth_tx_fifo_wrclk <= clk_125MHz;
    -- connect FWFT fifo interface
    control_fifo_rdclk    <= gig_eth_tx_fifo_wrclk;
    gig_eth_tx_fifo_q     <= control_fifo_q(31 DOWNTO 0);
    gig_eth_tx_fifo_wren  <= NOT control_fifo_empty;
    control_fifo_rdreq    <= NOT gig_eth_tx_fifo_full;
  END GENERATE gig_eth_cores;
  ---------------------------------------------> gig_eth
  ---------------------------------------------< SDRAM
  sdram_ddr3_inst : sdram_ddr3
    PORT MAP (
      CLK                   => sys_clk,  -- system clock, must be the same as intended in MIG
      REFCLK                => sys_clk,  -- 200MHz for iodelay
      RESET                 => reset,
      -- SDRAM_DDR3
      -- Inouts
      DDR3_DQ               => DDR3_DQ,
      DDR3_DQS_P            => DDR3_DQS_P,
      DDR3_DQS_N            => DDR3_DQS_N,
      -- Outputs
      DDR3_ADDR             => DDR3_ADDR,
      DDR3_BA               => DDR3_BA,
      DDR3_RAS_N            => DDR3_RAS_N,
      DDR3_CAS_N            => DDR3_CAS_N,
      DDR3_WE_N             => DDR3_WE_N,
      DDR3_RESET_N          => DDR3_RESET_N,
      DDR3_CK_P             => DDR3_CK_P,
      DDR3_CK_N             => DDR3_CK_N,
      DDR3_CKE              => DDR3_CKE,
      DDR3_CS_N             => DDR3_CS_N,
      DDR3_DM               => DDR3_DM,
      DDR3_ODT              => DDR3_ODT,
      -- Status Outputs
      INIT_CALIB_COMPLETE   => LED8Bit(4),
      -- Internal data r/w interface
      UI_CLK                => clk_200MHz,
      --
      CTRL_RESET            => pulse_reg(6),
      WR_START              => idata_data_wr_start,
      WR_ADDR_BEGIN         => config_reg(32*4+27 DOWNTO 32*4),
      WR_STOP               => pulse_reg(4),
      WR_WRAP_AROUND        => config_reg(32*4+28),
      POST_TRIGGER          => config_reg(32*5+27 DOWNTO 32*5),
      WR_BUSY               => idata_data_wr_busy,
      WR_POINTER            => OPEN,
      TRIGGER_POINTER       => status_reg(64*2+27 DOWNTO 64*2),
      WR_WRAPPED            => idata_data_wr_wrapped,
      RD_START              => pulse_reg(5),
      RD_ADDR_BEGIN         => (OTHERS => '0'),
      RD_ADDR_END           => config_reg(32*6+27 DOWNTO 32*6),
      RD_BUSY               => status_reg(64*2+30),
      --
      DATA_FIFO_RESET       => idata_data_fifo_reset,
      INDATA_FIFO_WRCLK     => idata_adc_data_clk,
      INDATA_FIFO_Q         => idata_idata_fifo_q,
      INDATA_FIFO_FULL      => idata_idata_fifo_full,
      INDATA_FIFO_WREN      => idata_idata_fifo_wren,
      --
      OUTDATA_FIFO_RDCLK    => idata_data_fifo_rdclk,
      OUTDATA_FIFO_Q        => idata_data_fifo_dout,
      OUTDATA_FIFO_EMPTY    => idata_data_fifo_empty,
      OUTDATA_FIFO_RDEN     => idata_data_fifo_rden,
      --
      DBG_APP_ADDR          => sdram_app_addr,
      DBG_APP_EN            => sdram_app_en,
      DBG_APP_RDY           => sdram_app_rdy,
      DBG_APP_WDF_DATA      => sdram_app_wdf_data,
      DBG_APP_WDF_END       => sdram_app_wdf_end,
      DBG_APP_WDF_WREN      => sdram_app_wdf_wren,
      DBG_APP_WDF_RDY       => sdram_app_wdf_rdy,
      DBG_APP_RD_DATA       => sdram_app_rd_data,
      DBG_APP_RD_DATA_VALID => sdram_app_rd_data_valid
    );
  idata_adc_data_clk    <= clk_125MHz;
  idata_data_fifo_reset <= pulse_reg(2);
  status_reg(64*2+28)   <= idata_data_wr_busy;
  status_reg(64*2+29)   <= idata_data_wr_wrapped;
  --
  channel_sel_inst : channel_sel
    PORT MAP (
      CLK             => idata_adc_data_clk,  -- fifo wrclk
      RESET           => reset,
      SEL             => config_reg(32*7+7 DOWNTO 32*7),
      --
      DATA_FIFO_RESET => idata_data_fifo_reset,
      --
      INDATA_Q        => idata_channel_avg_outdata_q,
      DATA_FIFO_WREN  => idata_data_fifo_wren,
      DATA_FIFO_FULL  => idata_data_fifo_full,
      --
      OUTDATA_FIFO_Q  => idata_idata_fifo_q,
      DATA_FIFO_RDEN  => idata_idata_fifo_rden,
      DATA_FIFO_EMPTY => idata_idata_fifo_empty
    );
  idata_idata_fifo_rden <= NOT idata_idata_fifo_full;
  idata_idata_fifo_wren <= NOT idata_idata_fifo_empty;
  idata_data_fifo_wren  <= config_reg(32*6+31) AND idata_channel_avg_outvalid;
  --
  channel_avg_inst : channel_avg
    PORT MAP (
      RESET           => reset,
      CLK             => idata_adc_data_clk,
      -- high 4-bit is offset, 2**(low 4-bit) is number of points to average
      CONFIG          => config_reg(32*7+15 DOWNTO 32*7+8),
      TRIG            => idata_data_wr_start,
      INDATA_Q        => idata_data_fifo_din,
      OUTVALID        => idata_channel_avg_outvalid,
      OUTDATA_Q       => idata_channel_avg_outdata_q
    );
  --
  dbg_ila_probe3(27 DOWNTO 0)               <= sdram_app_addr;
  dbg_ila_probe3(28)                        <= sdram_app_en;
  dbg_ila_probe3(29)                        <= sdram_app_rdy;
  dbg_ila_probe3(30)                        <= sdram_app_wdf_wren;
  dbg_ila_probe3(31)                        <= sdram_app_wdf_rdy;
  dbg_ila_probe3(32)                        <= sdram_app_wdf_end;
  dbg_ila_probe3(1023 DOWNTO 512)           <= sdram_app_wdf_data;
  dbg_ila_probe3(1024+1023 DOWNTO 1024+512) <= sdram_app_rd_data;
  dbg_ila_probe3(33)                        <= sdram_app_rd_data_valid;
  dbg_ila_probe3(511 DOWNTO 336)            <= status_reg;
  ---------------------------------------------> SDRAM
  ---------------------------------------------< I2C
  i2c_write_regmap_inst : i2c_write_regmap
    GENERIC MAP (
      -- file not used, see actual code.
      REGMAP_FNAME       => "../../../config/Si5324_125MHz_regmap.txt",
      INPUT_CLK_FREQENCY => 100_000_000,
      BUS_CLK_FREQUENCY  => 100_000
    )
    PORT MAP (
      CLK       => control_clk,
      RESET     => reset,
      START     => pulse_reg(15),
      EXT_RSTn  => SI5324_RSTn,
      BUSY      => status_reg(16*10+7),
      ACK_ERROR => status_reg(16*10+6),
      SDA_in    => i2c_sda_in,
      SDA_out   => i2c_sda_out,
      SDA_t     => i2c_sda_t,
      SCL       => i2c_scl_out
    );
  i2c_sda_iobuf_inst : IOBUF
    GENERIC MAP(
      DRIVE      => 12,
      SLEW       => "SLOW"
    )
    PORT MAP(
      O  => i2c_sda_in,
      IO => I2C_SDA,
      I  => i2c_sda_out,
      T  => i2c_sda_t
    );
  i2c_scl_iobuf_inst : IOBUF
    GENERIC MAP(
      DRIVE      => 12,
      SLEW       => "SLOW"
    )
    PORT MAP(
      O  => OPEN,
      IO => I2C_SCL,
      I  => i2c_scl_out,
      T  => '0'
    );
  -- External clock IC
  si5324clk_ibufds_inst : IBUFDS_GTE2
    PORT MAP (
      O     => clk_si5324_i,
      ODIV2 => OPEN,
      CEB   => '0',
      I     => SI5324CLK_P,
      IB    => SI5324CLK_N
    );
  si5324clk_bufg_inst : BUFG
    PORT MAP (
      I => clk_si5324_i,
      O => clk_si5324
    );
  si5324_clk_div_inst : clk_div
    GENERIC MAP (
      WIDTH => 32,
      PBITS => 8
    )
    PORT MAP (
      RESET   => reset,
      CLK     => clk_si5324,
      DIV     => x"1b",
      CLK_DIV => LED8Bit(0)
    );
  -- -- debug
  dbg_ila1_inst : dbg_ila1
    PORT MAP (
      CLK    => idata_adc_refout_clkdiv,
      PROBE0 => dbg_ila1_probe0,
      PROBE1 => dbg_ila1_probe1
    );
  dbg_ila1_probe0 <= (0 => pulse_reg(15), 1 => i2c_scl_out,
                      2 => i2c_sda_t, 3 => i2c_sda_in, 4 => i2c_sda_out, 5 => status_reg(16*10+6),
                      6 => clk_si5324,
                      OTHERS => '0');
  ---------------------------------------------> I2C

  -- clock output
  refout_clk_div_inst : clk_div
    PORT MAP (
      RESET   => reset,
      CLK     => idata_adc_data_clk,
      DIV     => config_reg(16*15+3 DOWNTO 16*15),
      CLK_DIV => idata_adc_refout_clkdiv
    );
  clk_fwd_inst : clk_fwd                -- idata_adc_refout_clkdiv
    PORT MAP (R => reset, I => clk_si5324, O => USER_SMA_CLOCK_P);
  clk_fwd_inst1 : clk_fwd GENERIC MAP (INV => true)
    PORT MAP (R => reset, I => clk_si5324, O => USER_SMA_CLOCK_N);
  clk_fwd_inst2 : clk_fwd GENERIC MAP (INV => true)
    PORT MAP (R => reset, I => idata_adc_data_clk, O => USER_SMA_GPIO_N);

  -- capture the rising edge of trigger
  trig_edge_sync_inst : edge_sync
    PORT MAP (
      RESET => reset,
      CLK   => control_clk,
      EI    => idata_trig_in,
      SO    => idata_trig_synced
    );
  idata_trig_allow    <= config_reg(32*6+30);
  idata_data_wr_start <= pulse_reg(3) OR (idata_trig_synced AND idata_trig_allow
                                          AND (NOT idata_data_wr_busy)
                                          AND (NOT idata_data_wr_wrapped));
  USER_SMA_GPIO_P <= idata_trig_synced;

  dbg_ila1_probe0 <= idata_adc_data0;
  dbg_ila1_probe1 <= idata_adc_data4;

  --led_obufs : FOR i IN 0 TO 7 GENERATE
  --  led_obuf : OBUF
  --    PORT MAP (
  --      I => usr_data_output(i),
  --      O => LED8Bit(i)
  --    );
  --END GENERATE led_obufs;
  --LED8Bit(5 DOWNTO 1) <= (OTHERS => '0');

END Behavioral;
