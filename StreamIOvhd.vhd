----------------------------------------------------------------------------------
-- Company: Digilent
-- Engineer: Aaron Odell
-- 
-- Create Date:    15:39:04 08/19/2010 
-- Design Name: StreamIO
-- Module Name: StreamIOvhd - Behavioral 
-- Description: Top level design for StreamIO project.
--		Instantiates StmCtrl and Memory modules.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity StreamIOvhd is
    Port ( 
	        SCLK : in  STD_LOGIC;
	        STROBE : in  STD_LOGIC;
	        SDATA0: in  STD_LOGIC_VECTOR (31 downto 0);
	        SDATA1: in  STD_LOGIC_VECTOR (31 downto 0);
	        ODATA: out  STD_LOGIC_VECTOR (31 downto 0);
	        IFCLK : in  STD_LOGIC;
           STMEN : in  STD_LOGIC;
           FLAGA : in  STD_LOGIC;
           FLAGB : in  STD_LOGIC;
           SLRD : out  STD_LOGIC;
           SLWR : out  STD_LOGIC;
           SLOE : out  STD_LOGIC;
           PKTEND : out  STD_LOGIC;
           FIFOADR : out  STD_LOGIC_VECTOR (1 downto 0);
           USBDB : inout  STD_LOGIC_VECTOR (7 downto 0));
end StreamIOvhd;

architecture Behavioral of StreamIOvhd is

	-- Component definitions
	COMPONENT StmCtrl
	PORT(
		IFCLK : IN std_logic;
		STMEN : IN std_logic;
		FLAGA : IN std_logic;
		FLAGB : IN std_logic;
		DOWNBSY : IN std_logic;
		DOWNACK : IN std_logic;
		UPBSY : IN std_logic;
		UPACK : IN std_logic;
		UPDATA : IN std_logic_vector(7 downto 0);    
		USBDB : INOUT std_logic_vector(7 downto 0);      
		SLRD : OUT std_logic;
		SLWR : OUT std_logic;
		SLOE : OUT std_logic;
		FIFOADR : OUT std_logic_vector(1 downto 0);
		PKTEND : OUT std_logic;
		DOWNWR : OUT std_logic;
		DOWNDATA : OUT std_logic_vector(7 downto 0);
		UPRD : OUT std_logic
		);
	END COMPONENT;

	COMPONENT usb_io
	PORT(
	   SCLK : IN std_logic;
	   STROBE : IN std_logic;
		SDATA0 : IN std_logic_vector(31 downto 0);
		SDATA1 : IN std_logic_vector(31 downto 0);
		ODATA : OUT std_logic_vector(31 downto 0);
		IFCLK : IN std_logic;
		RST : IN std_logic;
		DOWNWR : IN std_logic;
		DOWNDATA : IN std_logic_vector(7 downto 0);
		UPRD : IN std_logic;          
		DOWNBSY : OUT std_logic;
		DOWNACK : OUT std_logic;
		UPBSY : OUT std_logic;
		UPACK : OUT std_logic;
		UPDATA : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	
	-- Internal connections between StmCtrl and Memory
	signal downbsy : std_logic;
	signal downwr : std_logic;
	signal downack : std_logic;
	signal downdata : std_logic_vector(7 downto 0);
	signal upbsy : std_logic;
	signal uprd : std_logic;
	signal upack : std_logic;
	signal updata : std_logic_vector(7 downto 0);

begin

	-- Component instantiation
	StmCtrlInst: StmCtrl PORT MAP(
		IFCLK => IFCLK,
		STMEN => STMEN,
		FLAGA => FLAGA,
		FLAGB => FLAGB,
		SLRD => SLRD,
		SLWR => SLWR,
		SLOE => SLOE,
		FIFOADR => FIFOADR,
		PKTEND => PKTEND,
		USBDB => USBDB,
		DOWNBSY => downbsy,
		DOWNWR => downwr,
		DOWNACK => downack,
		DOWNDATA => downdata,
		UPBSY => upbsy,
		UPRD => uprd,
		UPACK => upack,
		UPDATA => updata
	);

	MemoryInst: usb_io PORT MAP(
	   SCLK => SCLK,
		STROBE => STROBE,
		SDATA0 => SDATA0,
		SDATA1 => SDATA1,
		ODATA => ODATA,
		IFCLK => IFCLK,
		RST => STMEN,
		DOWNBSY => downbsy,
		DOWNWR => downwr,
		DOWNACK => downack,
		DOWNDATA => downdata,
		UPBSY => upbsy,
		UPRD => uprd,
		UPACK => upack,
		UPDATA => updata
	);

end Behavioral;

