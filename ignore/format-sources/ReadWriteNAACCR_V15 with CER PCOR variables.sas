/* SAS PROGRAM TO READ AND WRITE NAACCR V15 RECORD LAYOUTS */

*** CHANGE FILE REFERENCES FOR INPUT AND OUTPUT FLAT ASCII FILES ***;

filename inv15     'V:\data\CANCER\NAACCR\DataStandardsAndDictionary\V15\IDtest7514textSAS.N15';
filename outv15    'V:\data\CANCER\NAACCR\DataStandardsAndDictionary\V15\Test2.txd';



data SAStest;  
* infile inv15 lrecl =  3339 pad missover; /* INCIDENCE */
* infile inv15 lrecl =  5564 pad missover; /* CONFIDENTIAL */
  infile inv15 lrecl = 22824 pad missover; /* TEXT */

/* INCIDENCE VARIABLES */
input @1    N15_10   $char1.  @; label N15_10   ='10_Record Type';   
input @2    N15_30   $char1.  @; label N15_30   ='30_Registry Type'; 
*input   @3    N15_37   $char14. @; *label   N15_37   ='37_Reserved 00';   
input @17   N15_50   $char3.  @; label N15_50   ='50_NAACCR Record Version';  
input @20   N15_45   $char10. @; label N15_45   ='45_NPI--Registry ID'; 
input @30   N15_40   $char10. @; label N15_40   ='40_Registry ID';   
input @40   N15_60   $char2.  @; label N15_60   ='60_Tumor Record Number'; 
input @42   N15_20   $char8.  @; label N15_20   ='20_Patient ID Number';   
input @50   N15_21   $char8.  @; label N15_21   ='21_Patient System ID-Hosp'; 
*input   @58   N15_370  $char37. @; *label   N15_370  ='370_Reserved 01';  
input @95   N15_70   $char50. @; label N15_70   ='70_Addr at DX--City'; 
input @145  N15_80   $char2.  @; label N15_80   ='80_Addr at DX--State';   /*Revised*/
input @147  N15_100  $char9.  @; label N15_100  ='100_Addr at DX--Postal Code';  
input @156  N15_90   $char3.  @; label N15_90   ='90_County at DX';  
input @159  N15_110  $char6.  @; label N15_110  ='110_Census Tract 1970/80/90';  
input @165  N15_368  $char1.  @; label N15_368  ='368_Census Block Grp 1970-90'; 
input @166  N15_120  $char1.  @; label N15_120  ='120_Census Cod Sys 1970/80/90';   
input @167  N15_364  $char1.  @; label N15_364  ='364_Census Tr Cert 1970/80/90';   
input @168  N15_130  $char6.  @; label N15_130  ='130_Census Tract 2000';  
input @174  N15_362  $char1.  @; label N15_362  ='362_Census Block Group 2000';  
input @175  N15_365  $char1.  @; label N15_365  ='365_Census Tr Certainty 2000'; 
input @176  N15_150  $char1.  @; label N15_150  ='150_Marital Status at DX';  
input @177  N15_160  $char2.  @; label N15_160  ='160_Race 1'; 
input @179  N15_161  $char2.  @; label N15_161  ='161_Race 2'; 
input @181  N15_162  $char2.  @; label N15_162  ='162_Race 3'; 
input @183  N15_163  $char2.  @; label N15_163  ='163_Race 4'; 
input @185  N15_164  $char2.  @; label N15_164  ='164_Race 5'; 
input @187  N15_170  $char1.  @; label N15_170  ='170_Race Coding Sys--Current'; 
input @188  N15_180  $char1.  @; label N15_180  ='180_Race Coding Sys--Original';   
input @189  N15_190  $char1.  @; label N15_190  ='190_Spanish/Hispanic Origin';  
input @190  N15_200  $char1.  @; label N15_200  ='200_Computed Ethnicity'; 
input @191  N15_210  $char1.  @; label N15_210  ='210_Computed Ethnicity Source';   
input @192  N15_220  $char1.  @; label N15_220  ='220_Sex'; 
input @193  N15_230  $char3.  @; label N15_230  ='230_Age at Diagnosis';   
input @196  N15_240  $char8.  @; label N15_240  ='240_Date of Birth';   
input @204  N15_241  $char2.  @; label N15_241  ='241_Date of Birth Flag'; 
input @206  N15_250  $char3.  @; label N15_250  ='250_Birthplace';   /*Revised*/
input @209  N15_270  $char3.  @; label N15_270  ='270_Census Occ Code 1970-2000';   
input @212  N15_280  $char3.  @; label N15_280  ='280_Census Ind Code 1970-2000';   
input @215  N15_290  $char1.  @; label N15_290  ='290_Occupation Source';  
input @216  N15_300  $char1.  @; label N15_300  ='300_Industry Source'; 
input @217  N15_310  $char100.   @; label N15_310  ='310_Text--Usual Occupation';   
input @317  N15_320  $char100.   @; label N15_320  ='320_Text--Usual Industry';  
input @417  N15_330  $char1.  @; label N15_330  ='330_Census Occ/Ind Sys 70-00'; 
input @418  N15_191  $char1.  @; label N15_191  ='191_NHIA Derived Hisp Origin'; 
input @419  N15_193  $char2.  @; label N15_193  ='193_Race--NAPIIA(derived API)';   
input @421  N15_192  $char1.  @; label N15_192  ='192_IHS Link';  
input @422  N15_366  $char2.  @; label N15_366  ='366_GIS Coordinate Quality';   
input @424  N15_3300 $char2.  @; label N15_3300 ='3300_RuralUrban Continuum 1993';  
input @426  N15_3310 $char2.  @; label N15_3310 ='3310_RuralUrban Continuum 2003';  
input @428  N15_135  $char6.  @; label N15_135  ='135_Census Tract 2010';  
input @434  N15_363  $char1.  @; label N15_363  ='363_Census Block Group 2010';  
input @435  N15_367  $char1.  @; label N15_367  ='367_Census Tr Certainty 2010'; 
input @436  N15_102  $char3.  @; label N15_102  ='102_Addr at DX--Country';   
input @439  N15_1832 $char3.  @; label N15_1832 ='1832_Addr Current--Country';   
input @442  N15_252  $char2.  @; label N15_252  ='252_Birthplace--State';  
input @444  N15_254  $char3.  @; label N15_254  ='254_Birthplace--Country';   
input @447  N15_1847 $char3.  @; label N15_1847 ='1847_FollowUp Contact--Country';  
input @450  N15_1942 $char2.  @; label N15_1942 ='1942_Place of Death--State';   
input @452  N15_1944 $char3.  @; label N15_1944 ='1944_Place of Death--Country'; 
input @455  N15_272  $char4.  @; label N15_272  ='272_Census Ind Code 2010';  
input @459  N15_282  $char4.  @; label N15_282  ='282_Census Occ Code 2010';  
input @463  N15_145  $char1.  @; label N15_145  ='145_Census Tr Poverty Indictr';   
*input   @464  N15_530  $char64. @; *label   N15_530  ='530_Reserved 02';  
input @528  N15_380  $char2.  @; label N15_380  ='380_Sequence Number--Central'; 
input @530  N15_390  $char8.  @; label N15_390  ='390_Date of Diagnosis';  /*Revised*/
input @538  N15_391  $char2.  @; label N15_391  ='391_Date of Diagnosis Flag';   
input @540  N15_400  $char4.  @; label N15_400  ='400_Primary Site'; 
input @544  N15_410  $char1.  @; label N15_410  ='410_Laterality';   
input @545  N15_419  $char5.  @; label N15_419  ='419_Morph--Type&Behav ICD-O-2';   
input @545  N15_420  $char4.  @; label N15_420  ='420_Histology (92-00) ICD-O-2';   
input @549  N15_430  $char1.  @; label N15_430  ='430_Behavior (92-00) ICD-O-2'; 
input @550  N15_521  $char5.  @; label N15_521  ='521_Morph--Type&Behav ICD-O-3';   
input @550  N15_522  $char4.  @; label N15_522  ='522_Histologic Type ICD-O-3';  
input @554  N15_523  $char1.  @; label N15_523  ='523_Behavior Code ICD-O-3'; 
input @555  N15_440  $char1.  @; label N15_440  ='440_Grade';  
input @556  N15_441  $char1.  @; label N15_441  ='441_Grade Path Value';   
input @557  N15_449  $char1.  @; label N15_449  ='449_Grade Path System';  
input @558  N15_450  $char1.  @; label N15_450  ='450_Site Coding Sys--Current'; 
input @559  N15_460  $char1.  @; label N15_460  ='460_Site Coding Sys--Original';   
input @560  N15_470  $char1.  @; label N15_470  ='470_Morph Coding Sys--Current';   
input @561  N15_480  $char1.  @; label N15_480  ='480_Morph Coding Sys--Originl';   
input @562  N15_490  $char1.  @; label N15_490  ='490_Diagnostic Confirmation';  
input @563  N15_500  $char1.  @; label N15_500  ='500_Type of Reporting Source'; 
input @564  N15_501  $char2.  @; label N15_501  ='501_Casefinding Source'; 
input @566  N15_442  $char1.  @; label N15_442  ='442_Ambiguous Terminology DX'; /*Revised*/
input @567  N15_443  $char8.  @; label N15_443  ='443_Date Conclusive DX'; /*Revised*/
input @575  N15_448  $char2.  @; label N15_448  ='448_Date Conclusive DX Flag';  /*Revised*/
input @577  N15_444  $char2.  @; label N15_444  ='444_Mult Tum Rpt as One Prim'; /*Revised*/
input @579  N15_445  $char8.  @; label N15_445  ='445_Date of Mult Tumors';   /*Revised*/
input @587  N15_439  $char2.  @; label N15_439  ='439_Date of Mult Tumors Flag'; /*Revised*/
input @589  N15_446  $char2.  @; label N15_446  ='446_Multiplicity Counter';  /*Revised*/
*input   @591  N15_680  $char100.   @; *label   N15_680  ='680_Reserved 03';  
input @691  N15_545  $char10. @; label N15_545  ='545_NPI--Reporting Facility';  
input @701  N15_540  $char10. @; label N15_540  ='540_Reporting Facility'; 
input @711  N15_3105 $char10. @; label N15_3105 ='3105_NPI--Archive FIN';  
input @721  N15_3100 $char10. @; label N15_3100 ='3100_Archive FIN'; 
input @731  N15_550  $char9.  @; label N15_550  ='550_Accession Number--Hosp';   
input @740  N15_560  $char2.  @; label N15_560  ='560_Sequence Number--Hospital';   /*Revised*/
input @742  N15_570  $char3.  @; label N15_570  ='570_Abstracted By';   
input @745  N15_580  $char8.  @; label N15_580  ='580_Date of 1st Contact';   
input @753  N15_581  $char2.  @; label N15_581  ='581_Date of 1st Contact Flag'; 
input @755  N15_590  $char8.  @; label N15_590  ='590_Date of Inpt Adm';   
input @763  N15_591  $char2.  @; label N15_591  ='591_Date of Inpt Adm Flag'; 
input @765  N15_600  $char8.  @; label N15_600  ='600_Date of Inpt Disch'; 
input @773  N15_601  $char2.  @; label N15_601  ='601_Date of Inpt Disch Flag';  
input @775  N15_605  $char1.  @; label N15_605  ='605_Inpatient Status';   
input @776  N15_610  $char2.  @; label N15_610  ='610_Class of Case';   
input @778  N15_630  $char2.  @; label N15_630  ='630_Primary Payer at DX';   
*input   @780  N15_2400 $char1.  @; *label   N15_2400 ='2400_Reserved 15'; 
input @781  N15_668  $char1.  @; label N15_668  ='668_RX Hosp--Surg App 2010';   
input @782  N15_670  $char2.  @; label N15_670  ='670_RX Hosp--Surg Prim Site';  
input @784  N15_672  $char1.  @; label N15_672  ='672_RX Hosp--Scope Reg LN Sur';   
input @785  N15_674  $char1.  @; label N15_674  ='674_RX Hosp--Surg Oth Reg/Dis';   
input @786  N15_676  $char2.  @; label N15_676  ='676_RX Hosp--Reg LN Removed';  
*input   @788  N15_2450 $char1.  @; *label   N15_2450 ='2450_Reserved 16'; 
input @789  N15_690  $char1.  @; label N15_690  ='690_RX Hosp--Radiation'; 
input @790  N15_700  $char2.  @; label N15_700  ='700_RX Hosp--Chemo';  
input @792  N15_710  $char2.  @; label N15_710  ='710_RX Hosp--Hormone';   
input @794  N15_720  $char2.  @; label N15_720  ='720_RX Hosp--BRM'; 
input @796  N15_730  $char1.  @; label N15_730  ='730_RX Hosp--Other';  
input @797  N15_740  $char2.  @; label N15_740  ='740_RX Hosp--DX/Stg Proc';  
input @799  N15_3280 $char1.  @; label N15_3280 ='3280_RX Hosp--Palliative Proc';   
input @800  N15_746  $char2.  @; label N15_746  ='746_RX Hosp--Surg Site 98-02'; 
input @802  N15_747  $char1.  @; label N15_747  ='747_RX Hosp--Scope Reg 98-02'; 
input @803  N15_748  $char1.  @; label N15_748  ='748_RX Hosp--Surg Oth 98-02';  
*input   @804  N15_750  $char100.   @; *label   N15_750  ='750_Reserved 04';  
input @904  N15_759  $char1.  @; label N15_759  ='759_SEER Summary Stage 2000';  /*Revised*/
input @905  N15_760  $char1.  @; label N15_760  ='760_SEER Summary Stage 1977';  
input @906  N15_779  $char12. @; label N15_779  ='779_Extent of Disease 10-Dig'; 
input @906  N15_780  $char3.  @; label N15_780  ='780_EOD--Tumor Size'; 
input @909  N15_790  $char2.  @; label N15_790  ='790_EOD--Extension';  
input @911  N15_800  $char2.  @; label N15_800  ='800_EOD--Extension Prost Path';   
input @913  N15_810  $char1.  @; label N15_810  ='810_EOD--Lymph Node Involv';   
input @914  N15_820  $char2.  @; label N15_820  ='820_Regional Nodes Positive';  
input @916  N15_830  $char2.  @; label N15_830  ='830_Regional Nodes Examined';  
input @918  N15_840  $char13. @; label N15_840  ='840_EOD--Old 13 Digit';  
input @931  N15_850  $char2.  @; label N15_850  ='850_EOD--Old 2 Digit';   
input @933  N15_860  $char4.  @; label N15_860  ='860_EOD--Old 4 Digit';   
input @937  N15_870  $char1.  @; label N15_870  ='870_Coding System for EOD'; 
input @938  N15_1060 $char2.  @; label N15_1060 ='1060_TNM Edition Number';   /*Revised*/
input @940  N15_880  $char4.  @; label N15_880  ='880_TNM Path T';   /*Revised*/
input @944  N15_890  $char4.  @; label N15_890  ='890_TNM Path N';   /*Revised*/
input @948  N15_900  $char4.  @; label N15_900  ='900_TNM Path M';   /*Revised*/
input @952  N15_910  $char4.  @; label N15_910  ='910_TNM Path Stage Group';  /*Revised*/
input @956  N15_920  $char1.  @; label N15_920  ='920_TNM Path Descriptor';   /*Revised*/
input @957  N15_930  $char1.  @; label N15_930  ='930_TNM Path Staged By'; /*Revised*/
input @958  N15_940  $char4.  @; label N15_940  ='940_TNM Clin T';   /*Revised*/
input @962  N15_950  $char4.  @; label N15_950  ='950_TNM Clin N';   /*Revised*/
input @966  N15_960  $char4.  @; label N15_960  ='960_TNM Clin M';   /*Revised*/
input @970  N15_970  $char4.  @; label N15_970  ='970_TNM Clin Stage Group';  /*Revised*/
input @974  N15_980  $char1.  @; label N15_980  ='980_TNM Clin Descriptor';   /*Revised*/
input @975  N15_990  $char1.  @; label N15_990  ='990_TNM Clin Staged By'; /*Revised*/
input @976  N15_1120 $char2.  @; label N15_1120 ='1120_Pediatric Stage';   
input @978  N15_1130 $char2.  @; label N15_1130 ='1130_Pediatric Staging System';   
input @980  N15_1140 $char1.  @; label N15_1140 ='1140_Pediatric Staged By';  
input @981  N15_1150 $char1.  @; label N15_1150 ='1150_Tumor Marker 1'; 
input @982  N15_1160 $char1.  @; label N15_1160 ='1160_Tumor Marker 2'; 
input @983  N15_1170 $char1.  @; label N15_1170 ='1170_Tumor Marker 3'; 
input @984  N15_1182 $char1.  @; label N15_1182 ='1182_Lymph-vascular Invasion'; 
input @985  N15_2800 $char3.  @; label N15_2800 ='2800_CS Tumor Size';  
input @988  N15_2810 $char3.  @; label N15_2810 ='2810_CS Extension';   
input @991  N15_2820 $char1.  @; label N15_2820 ='2820_CS Tumor Size/Ext Eval';  
input @992  N15_2830 $char3.  @; label N15_2830 ='2830_CS Lymph Nodes'; 
input @995  N15_2840 $char1.  @; label N15_2840 ='2840_CS Lymph Nodes Eval';  
input @996  N15_2850 $char2.  @; label N15_2850 ='2850_CS Mets at DX';  
input @998  N15_2860 $char1.  @; label N15_2860 ='2860_CS Mets Eval';   
input @999  N15_2851 $char1.  @; label N15_2851 ='2851_CS Mets at Dx-Bone';   
input @1000 N15_2852 $char1.  @; label N15_2852 ='2852_CS Mets at Dx-Brain';  
input @1001 N15_2853 $char1.  @; label N15_2853 ='2853_CS Mets at Dx-Liver';  
input @1002 N15_2854 $char1.  @; label N15_2854 ='2854_CS Mets at Dx-Lung';   
input @1003 N15_2880 $char3.  @; label N15_2880 ='2880_CS Site-Specific Factor 1';  
input @1006 N15_2890 $char3.  @; label N15_2890 ='2890_CS Site-Specific Factor 2';  
input @1009 N15_2900 $char3.  @; label N15_2900 ='2900_CS Site-Specific Factor 3';  
input @1012 N15_2910 $char3.  @; label N15_2910 ='2910_CS Site-Specific Factor 4';  
input @1015 N15_2920 $char3.  @; label N15_2920 ='2920_CS Site-Specific Factor 5';  
input @1018 N15_2930 $char3.  @; label N15_2930 ='2930_CS Site-Specific Factor 6';  
input @1021 N15_2861 $char3.  @; label N15_2861 ='2861_CS Site-Specific Factor 7';  
input @1024 N15_2862 $char3.  @; label N15_2862 ='2862_CS Site-Specific Factor 8';  
input @1027 N15_2863 $char3.  @; label N15_2863 ='2863_CS Site-Specific Factor 9';  
input @1030 N15_2864 $char3.  @; label N15_2864 ='2864_CS Site-Specific Factor10';  
input @1033 N15_2865 $char3.  @; label N15_2865 ='2865_CS Site-Specific Factor11';  
input @1036 N15_2866 $char3.  @; label N15_2866 ='2866_CS Site-Specific Factor12';  
input @1039 N15_2867 $char3.  @; label N15_2867 ='2867_CS Site-Specific Factor13';  
input @1042 N15_2868 $char3.  @; label N15_2868 ='2868_CS Site-Specific Factor14';  
input @1045 N15_2869 $char3.  @; label N15_2869 ='2869_CS Site-Specific Factor15';  
input @1048 N15_2870 $char3.  @; label N15_2870 ='2870_CS Site-Specific Factor16';  
input @1051 N15_2871 $char3.  @; label N15_2871 ='2871_CS Site-Specific Factor17';  
input @1054 N15_2872 $char3.  @; label N15_2872 ='2872_CS Site-Specific Factor18';  
input @1057 N15_2873 $char3.  @; label N15_2873 ='2873_CS Site-Specific Factor19';  
input @1060 N15_2874 $char3.  @; label N15_2874 ='2874_CS Site-Specific Factor20';  
input @1063 N15_2875 $char3.  @; label N15_2875 ='2875_CS Site-Specific Factor21';  
input @1066 N15_2876 $char3.  @; label N15_2876 ='2876_CS Site-Specific Factor22';  
input @1069 N15_2877 $char3.  @; label N15_2877 ='2877_CS Site-Specific Factor23';  
input @1072 N15_2878 $char3.  @; label N15_2878 ='2878_CS Site-Specific Factor24';  
input @1075 N15_2879 $char3.  @; label N15_2879 ='2879_CS Site-Specific Factor25';  
input @1078 N15_2730 $char3.  @; label N15_2730 ='2730_CS PreRx Tumor Size';  
input @1081 N15_2735 $char3.  @; label N15_2735 ='2735_CS PreRx Extension';   
input @1084 N15_2740 $char1.  @; label N15_2740 ='2740_CS PreRx Tum Sz/Ext Eval';   
input @1085 N15_2750 $char3.  @; label N15_2750 ='2750_CS PreRx Lymph Nodes'; 
input @1088 N15_2755 $char1.  @; label N15_2755 ='2755_CS PreRx Reg Nodes Eval'; 
input @1089 N15_2760 $char2.  @; label N15_2760 ='2760_CS PreRx Mets at DX';  
input @1091 N15_2765 $char1.  @; label N15_2765 ='2765_CS PreRx Mets Eval';   
input @1092 N15_2770 $char3.  @; label N15_2770 ='2770_CS PostRx Tumor Size'; 
input @1095 N15_2775 $char3.  @; label N15_2775 ='2775_CS PostRx Extension';  
input @1098 N15_2780 $char3.  @; label N15_2780 ='2780_CS PostRx Lymph Nodes';   
input @1101 N15_2785 $char2.  @; label N15_2785 ='2785_CS PostRx Mets at DX'; 
input @1103 N15_2940 $char2.  @; label N15_2940 ='2940_Derived AJCC-6 T';  
input @1105 N15_2950 $char1.  @; label N15_2950 ='2950_Derived AJCC-6 T Descript';  
input @1106 N15_2960 $char2.  @; label N15_2960 ='2960_Derived AJCC-6 N';  
input @1108 N15_2970 $char1.  @; label N15_2970 ='2970_Derived AJCC-6 N Descript';  
input @1109 N15_2980 $char2.  @; label N15_2980 ='2980_Derived AJCC-6 M';  
input @1111 N15_2990 $char1.  @; label N15_2990 ='2990_Derived AJCC-6 M Descript';  
input @1112 N15_3000 $char2.  @; label N15_3000 ='3000_Derived AJCC-6 Stage Grp';   
input @1114 N15_3400 $char3.  @; label N15_3400 ='3400_Derived AJCC-7 T';  
input @1117 N15_3402 $char1.  @; label N15_3402 ='3402_Derived AJCC-7 T Descript';  
input @1118 N15_3410 $char3.  @; label N15_3410 ='3410_Derived AJCC-7 N';  
input @1121 N15_3412 $char1.  @; label N15_3412 ='3412_Derived AJCC-7 N Descript';  
input @1122 N15_3420 $char3.  @; label N15_3420 ='3420_Derived AJCC-7 M';  
input @1125 N15_3422 $char1.  @; label N15_3422 ='3422_Derived AJCC-7 M Descript';  
input @1126 N15_3430 $char3.  @; label N15_3430 ='3430_Derived AJCC-7 Stage Grp';   
input @1129 N15_3440 $char3.  @; label N15_3440 ='3440_Derived PreRx-7 T'; 
input @1132 N15_3442 $char1.  @; label N15_3442 ='3442_Derived PreRx-7 T Descrip';  
input @1133 N15_3450 $char3.  @; label N15_3450 ='3450_Derived PreRx-7 N'; 
input @1136 N15_3452 $char1.  @; label N15_3452 ='3452_Derived PreRx-7 N Descrip';  
input @1137 N15_3460 $char3.  @; label N15_3460 ='3460_Derived PreRx-7 M'; 
input @1140 N15_3462 $char1.  @; label N15_3462 ='3462_Derived PreRx-7 M Descrip';  
input @1141 N15_3470 $char3.  @; label N15_3470 ='3470_Derived PreRx-7 Stage Grp';  
input @1144 N15_3480 $char3.  @; label N15_3480 ='3480_Derived PostRx-7 T';   
input @1147 N15_3482 $char3.  @; label N15_3482 ='3482_Derived PostRx-7 N';   
input @1150 N15_3490 $char2.  @; label N15_3490 ='3490_Derived PostRx-7 M';   
input @1152 N15_3492 $char3.  @; label N15_3492 ='3492_Derived PostRx-7 Stge Grp';  
input @1155 N15_3010 $char1.  @; label N15_3010 ='3010_Derived SS1977'; 
input @1156 N15_3020 $char1.  @; label N15_3020 ='3020_Derived SS2000'; 
input @1157 N15_3600 $char1.  @; label N15_3600 ='3600_Derived Neoadjuv Rx Flag';   
input @1158 N15_3030 $char1.  @; label N15_3030 ='3030_Derived AJCC--Flag';   
input @1159 N15_3040 $char1.  @; label N15_3040 ='3040_Derived SS1977--Flag'; 
input @1160 N15_3050 $char1.  @; label N15_3050 ='3050_Derived SS2000--Flag'; 
input @1161 N15_2937 $char6.  @; label N15_2937 ='2937_CS Version Input Current';   
input @1167 N15_2935 $char6.  @; label N15_2935 ='2935_CS Version Input Original';  
input @1173 N15_2936 $char6.  @; label N15_2936 ='2936_CS Version Derived';   
input @1179 N15_3700 $char1.  @; label N15_3700 ='3700_SEER Site-Specific Fact 1';  
input @1180 N15_3702 $char1.  @; label N15_3702 ='3702_SEER Site-Specific Fact 2';  
input @1181 N15_3704 $char1.  @; label N15_3704 ='3704_SEER Site-Specific Fact 3';  
input @1182 N15_3706 $char1.  @; label N15_3706 ='3706_SEER Site-Specific Fact 4';  
input @1183 N15_3708 $char1.  @; label N15_3708 ='3708_SEER Site-Specific Fact 5';  
input @1184 N15_3710 $char1.  @; label N15_3710 ='3710_SEER Site-Specific Fact 6';  
input @1185 N15_3165 $char1.  @; label N15_3165 ='3165_ICD Revision Comorbid';   /*Revised*/
input @1186 N15_3110 $char5.  @; label N15_3110 ='3110_Comorbid/Complication 1'; 
input @1191 N15_3120 $char5.  @; label N15_3120 ='3120_Comorbid/Complication 2'; 
input @1196 N15_3130 $char5.  @; label N15_3130 ='3130_Comorbid/Complication 3'; 
input @1201 N15_3140 $char5.  @; label N15_3140 ='3140_Comorbid/Complication 4'; 
input @1206 N15_3150 $char5.  @; label N15_3150 ='3150_Comorbid/Complication 5'; 
input @1211 N15_3160 $char5.  @; label N15_3160 ='3160_Comorbid/Complication 6'; 
input @1216 N15_3161 $char5.  @; label N15_3161 ='3161_Comorbid/Complication 7'; 
input @1221 N15_3162 $char5.  @; label N15_3162 ='3162_Comorbid/Complication 8'; 
input @1226 N15_3163 $char5.  @; label N15_3163 ='3163_Comorbid/Complication 9'; 
input @1231 N15_3164 $char5.  @; label N15_3164 ='3164_Comorbid/Complication 10';   
input @1236 N15_3780 $char7.  @; label N15_3780 ='3780_Secondary Diagnosis 1';   
input @1243 N15_3782 $char7.  @; label N15_3782 ='3782_Secondary Diagnosis 2';   
input @1250 N15_3784 $char7.  @; label N15_3784 ='3784_Secondary Diagnosis 3';   
input @1257 N15_3786 $char7.  @; label N15_3786 ='3786_Secondary Diagnosis 4';   
input @1264 N15_3788 $char7.  @; label N15_3788 ='3788_Secondary Diagnosis 5';   
input @1271 N15_3790 $char7.  @; label N15_3790 ='3790_Secondary Diagnosis 6';   
input @1278 N15_3792 $char7.  @; label N15_3792 ='3792_Secondary Diagnosis 7';   
input @1285 N15_3794 $char7.  @; label N15_3794 ='3794_Secondary Diagnosis 8';   
input @1292 N15_3796 $char7.  @; label N15_3796 ='3796_Secondary Diagnosis 9';   
input @1299 N15_3798 $char7.  @; label N15_3798 ='3798_Secondary Diagnosis 10';  
         
   
/* NPCR-SPECIFIC FIELDS FOR NBCCEDP LINKAGE */                          
input @1306 N15_9980 $char1.  @; label N15_9980 ='9980_EDP MDE Link';   
input @1307 N15_9981 $char8.  @; label N15_9981 ='9981_EDP MDE Link Date'; 


/* NPCR-SPECIFIC FIELDS FOR FOREVER 7 CER VARIABLES - ONLY FOR CER STATES */
input @1315 N15_9960 $char2.  @; label N15_9960 ='9960_Height';   
input @1317 N15_9961 $char3.  @; label N15_9961 ='9961_Weight';   
input @1320 N15_9965 $char1.  @; label N15_9965 ='9965_Tobacco Use Cigarettes';  
input @1321 N15_9966 $char1.  @; label N15_9966 ='9966_Tobacco Use Other Smoke'; 
input @1322 N15_9967 $char1.  @; label N15_9967 ='9967_Tobacco Use Smokeless';   
input @1323 N15_9968 $char1.  @; label N15_9968 ='9968_Tobacco Use NOS';   
input @1324 N15_9970 $char1.  @; label N15_9970 ='9970_Source Comorbidity';
   
*input   @1325 N15_3720 $char56. @; *label   N15_3720 ='3720_NPCR Specific Field 1';
*input   @1381 N15_1180 $char55. @; *label   N15_1180 ='1180_Reserved 05'; 


/* NPCR-SPECIFIC FIELDS FOR PCOR VARIABLES - ONLY FOR PCOR STATES */ 
input @1348 N15_8001 $char1.  @; label N15_8001 ='8001_Comp1stCrsRxStat';  
input @1325 N15_9969 $char1.  @; label N15_9969 ='9969_Over-ride CER';  
input @1326 N15_8003 $char1.  @; label N15_8003 ='8003_Comp1stCrsStatusDatSrc';  
input @1327 N15_8004 $char1.  @; label N15_8004 ='8004_DsFreeStatus';   
input @1328 N15_8006 $char1.  @; label N15_8006 ='8006_FrstDsFreeDatSrcUsd';  
input @1329 N15_8007 $char1.  @; label N15_8007 ='8007_AddnlDsFreeStatus'; 
input @1330 N15_8009 $char1.  @; label N15_8009 ='8009_AddnlDsFreeDatSrcUsd'; 
input @1331 N15_8010 $char1.  @; label N15_8010 ='8010_RecStatus';   
input @1332 N15_8012 $char2.  @; label N15_8012 ='8012_TypeOfRecurrence';  
input @1334 N15_8013 $char1.  @; label N15_8013 ='8013_RcrDatSrc';   
input @1335 N15_8014 $char1.  @; label N15_8014 ='8014_ProgResidDsStatus'; 
input @1336 N15_8016 $char1.  @; label N15_8016 ='8016_ProgResidDatSrcUsd';   
input @1337 N15_8017 $char1.  @; label N15_8017 ='8017_SubseqPrmryStatus'; 
input @1338 N15_8019 $char1.  @; label N15_8019 ='8019_SubseqPrmryDatSrcUsd'; 
input @1339 N15_8022 $char2.  @; label N15_8022 ='8022_PCOR_SubseqRx2ndCrsSurg'; 
input @1341 N15_8023 $char2.  @; label N15_8023 ='8023_PCOR_SubseqRx2ndCrsRad';  
input @1343 N15_8024 $char2.  @; label N15_8024 ='8024_PCOR_SubseqRx2ndCrsChemo';   
input @1345 N15_8025 $char2.  @; label N15_8025 ='8025_PCOR_SubseqRx2ndCrsBRM';  
input @1347 N15_8026 $char1.  @; label N15_8026 ='8026_PCOR_SubseqRx2ndCrsOther';   
                        
                        
input @1436 N15_1260 $char8.  @; label N15_1260 ='1260_Date Initial RX SEER'; 
input @1444 N15_1261 $char2.  @; label N15_1261 ='1261_Date Initial RX SEER Flag';  
input @1446 N15_1270 $char8.  @; label N15_1270 ='1270_Date 1st Crs RX CoC';  
input @1454 N15_1271 $char2.  @; label N15_1271 ='1271_Date 1st Crs RX CoC Flag';   
input @1456 N15_1200 $char8.  @; label N15_1200 ='1200_RX Date Surgery';   /*Revised*/
input @1464 N15_1201 $char2.  @; label N15_1201 ='1201_RX Date Surgery Flag'; /*Revised*/
input @1466 N15_3170 $char8.  @; label N15_3170 ='3170_RX Date Mst Defn Srg'; /*Revised*/
input @1474 N15_3171 $char2.  @; label N15_3171 ='3171_RX Date Mst Defn Srg Flag';  /*Revised*/
input @1476 N15_3180 $char8.  @; label N15_3180 ='3180_RX Date Surg Disch';   
input @1484 N15_3181 $char2.  @; label N15_3181 ='3181_RX Date Surg Disch Flag'; 
input @1486 N15_1210 $char8.  @; label N15_1210 ='1210_RX Date Radiation'; /*Revised*/
input @1494 N15_1211 $char2.  @; label N15_1211 ='1211_RX Date Radiation Flag';  /*Revised*/
input @1496 N15_3220 $char8.  @; label N15_3220 ='3220_RX Date Rad Ended'; 
input @1504 N15_3221 $char2.  @; label N15_3221 ='3221_RX Date Rad Ended Flag';  
input @1506 N15_3230 $char8.  @; label N15_3230 ='3230_RX Date Systemic';  
input @1514 N15_3231 $char2.  @; label N15_3231 ='3231_RX Date Systemic Flag';   
input @1516 N15_1220 $char8.  @; label N15_1220 ='1220_RX Date Chemo';  /*Revised*/
input @1524 N15_1221 $char2.  @; label N15_1221 ='1221_RX Date Chemo Flag';   /*Revised*/
input @1526 N15_1230 $char8.  @; label N15_1230 ='1230_RX Date Hormone';   /*Revised*/
input @1534 N15_1231 $char2.  @; label N15_1231 ='1231_RX Date Hormone Flag'; /*Revised*/
input @1536 N15_1240 $char8.  @; label N15_1240 ='1240_RX Date BRM'; /*Revised*/
input @1544 N15_1241 $char2.  @; label N15_1241 ='1241_RX Date BRM Flag';  /*Revised*/
input @1546 N15_1250 $char8.  @; label N15_1250 ='1250_RX Date Other';  /*Revised*/
input @1554 N15_1251 $char2.  @; label N15_1251 ='1251_RX Date Other Flag';   /*Revised*/
input @1556 N15_1280 $char8.  @; label N15_1280 ='1280_RX Date DX/Stg Proc';  
input @1564 N15_1281 $char2.  @; label N15_1281 ='1281_RX Date DX/Stg Proc Flag';   
input @1566 N15_1285 $char1.  @; label N15_1285 ='1285_RX Summ--Treatment Status';  /*Revised*/
input @1567 N15_1290 $char2.  @; label N15_1290 ='1290_RX Summ--Surg Prim Site'; 
input @1569 N15_1292 $char1.  @; label N15_1292 ='1292_RX Summ--Scope Reg LN Sur';  
input @1570 N15_1294 $char1.  @; label N15_1294 ='1294_RX Summ--Surg Oth Reg/Dis';  
input @1571 N15_1296 $char2.  @; label N15_1296 ='1296_RX Summ--Reg LN Examined';   
input @1573 N15_1310 $char1.  @; label N15_1310 ='1310_RX Summ--Surgical Approch';  
input @1574 N15_1320 $char1.  @; label N15_1320 ='1320_RX Summ--Surgical Margins';  
input @1575 N15_1330 $char1.  @; label N15_1330 ='1330_RX Summ--Reconstruct 1st';   
input @1576 N15_1340 $char1.  @; label N15_1340 ='1340_Reason for No Surgery';   
input @1577 N15_1350 $char2.  @; label N15_1350 ='1350_RX Summ--DX/Stg Proc'; 
input @1579 N15_3270 $char1.  @; label N15_3270 ='3270_RX Summ--Palliative Proc';   
input @1580 N15_1360 $char1.  @; label N15_1360 ='1360_RX Summ--Radiation';   
input @1581 N15_1370 $char1.  @; label N15_1370 ='1370_RX Summ--Rad to CNS';  /*Revised*/
input @1582 N15_1380 $char1.  @; label N15_1380 ='1380_RX Summ--Surg/Rad Seq';   /*Revised*/
input @1583 N15_3250 $char2.  @; label N15_3250 ='3250_RX Summ--Transplnt/Endocr';  /*Revised*/
input @1585 N15_1390 $char2.  @; label N15_1390 ='1390_RX Summ--Chemo'; /*Revised*/
input @1587 N15_1400 $char2.  @; label N15_1400 ='1400_RX Summ--Hormone';  /*Revised*/
input @1589 N15_1410 $char2.  @; label N15_1410 ='1410_RX Summ--BRM';   /*Revised*/
input @1591 N15_1420 $char1.  @; label N15_1420 ='1420_RX Summ--Other'; /*Revised*/
input @1592 N15_1430 $char1.  @; label N15_1430 ='1430_Reason for No Radiation'; /*Revised*/
input @1593 N15_1460 $char2.  @; label N15_1460 ='1460_RX Coding System--Current';  
*input   @1595 N15_2161 $char1.  @; *label   N15_2161 ='2161_Reserved 18'; 
input @1596 N15_1510 $char5.  @; label N15_1510 ='1510_Rad--Regional Dose: cGy'; 
input @1601 N15_1520 $char3.  @; label N15_1520 ='1520_Rad--No of Treatment Vol';   
input @1604 N15_1540 $char2.  @; label N15_1540 ='1540_Rad--Treatment Volume';   
input @1606 N15_1550 $char1.  @; label N15_1550 ='1550_Rad--Location of RX';  
input @1607 N15_1570 $char2.  @; label N15_1570 ='1570_Rad--Regional RX Modality';  /*Revised*/
input @1609 N15_3200 $char2.  @; label N15_3200 ='3200_Rad--Boost RX Modality';  
input @1611 N15_3210 $char5.  @; label N15_3210 ='3210_Rad--Boost Dose cGy';  
input @1616 N15_1639 $char1.  @; label N15_1639 ='1639_RX Summ--Systemic/Sur Seq';  /*Revised*/
input @1617 N15_1640 $char2.  @; label N15_1640 ='1640_RX Summ--Surgery Type';   
input @1619 N15_3190 $char1.  @; label N15_3190 ='3190_Readm Same Hosp 30 Days'; 
input @1620 N15_1646 $char2.  @; label N15_1646 ='1646_RX Summ--Surg Site 98-02';   
input @1622 N15_1647 $char1.  @; label N15_1647 ='1647_RX Summ--Scope Reg 98-02';   
input @1623 N15_1648 $char1.  @; label N15_1648 ='1648_RX Summ--Surg Oth 98-02'; 
*input   @1624 N15_1190 $char100.   @; *label   N15_1190 ='1190_Reserved 06'; 
input @1724 N15_1660 $char8.  @; label N15_1660 ='1660_Subsq RX 2nd Course Date';   
input @1732 N15_1661 $char2.  @; label N15_1661 ='1661_Subsq RX 2ndCrs Date Flag';  
input @1734 N15_1670 $char11. @; label N15_1670 ='1670_Subsq RX 2nd Course Codes';  
input @1734 N15_1671 $char2.  @; label N15_1671 ='1671_Subsq RX 2nd Course Surg';   
input @1736 N15_1677 $char1.  @; label N15_1677 ='1677_Subsq RX 2nd--Scope LN SU';  
input @1737 N15_1678 $char1.  @; label N15_1678 ='1678_Subsq RX 2nd--Surg Oth';  
input @1738 N15_1679 $char2.  @; label N15_1679 ='1679_Subsq RX 2nd--Reg LN Rem';   
input @1740 N15_1672 $char1.  @; label N15_1672 ='1672_Subsq RX 2nd Course Rad'; 
input @1741 N15_1673 $char1.  @; label N15_1673 ='1673_Subsq RX 2nd Course Chemo';  
input @1742 N15_1674 $char1.  @; label N15_1674 ='1674_Subsq RX 2nd Course Horm';   
input @1743 N15_1675 $char1.  @; label N15_1675 ='1675_Subsq RX 2nd Course BRM'; 
input @1744 N15_1676 $char1.  @; label N15_1676 ='1676_Subsq RX 2nd Course Oth'; 
input @1745 N15_1680 $char8.  @; label N15_1680 ='1680_Subsq RX 3rd Course Date';   
input @1753 N15_1681 $char2.  @; label N15_1681 ='1681_Subsq RX 3rdCrs Date Flag';  
input @1755 N15_1690 $char11. @; label N15_1690 ='1690_Subsq RX 3rd Course Codes';  
input @1755 N15_1691 $char2.  @; label N15_1691 ='1691_Subsq RX 3rd Course Surg';   
input @1757 N15_1697 $char1.  @; label N15_1697 ='1697_Subsq RX 3rd--Scope LN Su';  
input @1758 N15_1698 $char1.  @; label N15_1698 ='1698_Subsq RX 3rd--Surg Oth';  
input @1759 N15_1699 $char2.  @; label N15_1699 ='1699_Subsq RX 3rd--Reg LN Rem';   
input @1761 N15_1692 $char1.  @; label N15_1692 ='1692_Subsq RX 3rd Course Rad'; 
input @1762 N15_1693 $char1.  @; label N15_1693 ='1693_Subsq RX 3rd Course Chemo';  
input @1763 N15_1694 $char1.  @; label N15_1694 ='1694_Subsq RX 3rd Course Horm';   
input @1764 N15_1695 $char1.  @; label N15_1695 ='1695_Subsq RX 3rd Course BRM'; 
input @1765 N15_1696 $char1.  @; label N15_1696 ='1696_Subsq RX 3rd Course Oth'; 
input @1766 N15_1700 $char8.  @; label N15_1700 ='1700_Subsq RX 4th Course Date';   
input @1774 N15_1701 $char2.  @; label N15_1701 ='1701_Subsq RX 4thCrs Date Flag';  
input @1776 N15_1710 $char11. @; label N15_1710 ='1710_Subsq RX 4th Course Codes';  
input @1776 N15_1711 $char2.  @; label N15_1711 ='1711_Subsq RX 4th Course Surg';   
input @1778 N15_1717 $char1.  @; label N15_1717 ='1717_Subsq RX 4th--Scope LN Su';  
input @1779 N15_1718 $char1.  @; label N15_1718 ='1718_Subsq RX 4th--Surg Oth';  
input @1780 N15_1719 $char2.  @; label N15_1719 ='1719_Subsq RX 4th--Reg LN Rem';   
input @1782 N15_1712 $char1.  @; label N15_1712 ='1712_Subsq RX 4th Course Rad'; 
input @1783 N15_1713 $char1.  @; label N15_1713 ='1713_Subsq RX 4th Course Chemo';  
input @1784 N15_1714 $char1.  @; label N15_1714 ='1714_Subsq RX 4th Course Horm';   
input @1785 N15_1715 $char1.  @; label N15_1715 ='1715_Subsq RX 4th Course BRM'; 
input @1786 N15_1716 $char1.  @; label N15_1716 ='1716_Subsq RX 4th Course Oth'; 
input @1787 N15_1741 $char1.  @; label N15_1741 ='1741_Subsq RX--Reconstruct Del';  
*input   @1788 N15_1300 $char100.   @; *label   N15_1300 ='1300_Reserved 07'; 
input @1888 N15_1981 $char1.  @; label N15_1981 ='1981_Over-ride SS/NodesPos';   
input @1889 N15_1982 $char1.  @; label N15_1982 ='1982_Over-ride SS/TNM-N';   
input @1890 N15_1983 $char1.  @; label N15_1983 ='1983_Over-ride SS/TNM-M';   
input @1891 N15_1985 $char1.  @; label N15_1985 ='1985_Over-ride Acsn/Class/Seq';   
input @1892 N15_1986 $char1.  @; label N15_1986 ='1986_Over-ride HospSeq/DxConf';   
input @1893 N15_1987 $char1.  @; label N15_1987 ='1987_Over-ride CoC-Site/Type'; 
input @1894 N15_1988 $char1.  @; label N15_1988 ='1988_Over-ride HospSeq/Site';  
input @1895 N15_1989 $char1.  @; label N15_1989 ='1989_Over-ride Site/TNM-StgGrp';  /*Revised*/
input @1896 N15_1990 $char1.  @; label N15_1990 ='1990_Over-ride Age/Site/Morph';   
input @1897 N15_2000 $char1.  @; label N15_2000 ='2000_Over-ride SeqNo/DxConf';  
input @1898 N15_2010 $char1.  @; label N15_2010 ='2010_Over-ride Site/Lat/SeqNo';   
input @1899 N15_2020 $char1.  @; label N15_2020 ='2020_Over-ride Surg/DxConf';   
input @1900 N15_2030 $char1.  @; label N15_2030 ='2030_Over-ride Site/Type';  
input @1901 N15_2040 $char1.  @; label N15_2040 ='2040_Over-ride Histology';  
input @1902 N15_2050 $char1.  @; label N15_2050 ='2050_Over-ride Report Source'; 
input @1903 N15_2060 $char1.  @; label N15_2060 ='2060_Over-ride Ill-define Site';  
input @1904 N15_2070 $char1.  @; label N15_2070 ='2070_Over-ride Leuk, Lymphoma';   
input @1905 N15_2071 $char1.  @; label N15_2071 ='2071_Over-ride Site/Behavior'; 
input @1906 N15_2072 $char1.  @; label N15_2072 ='2072_Over-ride Site/EOD/DX Dt';   
input @1907 N15_2073 $char1.  @; label N15_2073 ='2073_Over-ride Site/Lat/EOD';  
input @1908 N15_2074 $char1.  @; label N15_2074 ='2074_Over-ride Site/Lat/Morph';   
input @1909 N15_1960 $char4.  @; label N15_1960 ='1960_Site (73-91) ICD-O-1'; 
input @1913 N15_1970 $char6.  @; label N15_1970 ='1970_Morph (73-91) ICD-O-1';   
input @1913 N15_1971 $char4.  @; label N15_1971 ='1971_Histology (73-91) ICD-O-1';  
input @1917 N15_1972 $char1.  @; label N15_1972 ='1972_Behavior (73-91) ICD-O-1';   
input @1918 N15_1973 $char1.  @; label N15_1973 ='1973_Grade (73-91) ICD-O-1';   
input @1919 N15_1980 $char1.  @; label N15_1980 ='1980_ICD-O-2 Conversion Flag'; 
input @1920 N15_2081 $char10. @; label N15_2081 ='2081_CRC CHECKSUM';   
input @1930 N15_2120 $char1.  @; label N15_2120 ='2120_SEER Coding Sys--Current';   
input @1931 N15_2130 $char1.  @; label N15_2130 ='2130_SEER Coding Sys--Original';  
input @1932 N15_2140 $char2.  @; label N15_2140 ='2140_CoC Coding Sys--Current'; 
input @1934 N15_2150 $char2.  @; label N15_2150 ='2150_CoC Coding Sys--Original';   
input @1936 N15_2170 $char10. @; label N15_2170 ='2170_Vendor Name'; 
input @1946 N15_2180 $char1.  @; label N15_2180 ='2180_SEER Type of Follow-Up';  
input @1947 N15_2190 $char2.  @; label N15_2190 ='2190_SEER Record Number';   
input @1949 N15_2200 $char2.  @; label N15_2200 ='2200_Diagnostic Proc 73-87';   
input @1951 N15_2085 $char8.  @; label N15_2085 ='2085_Date Case Initiated';  
input @1959 N15_2090 $char8.  @; label N15_2090 ='2090_Date Case Completed';  
input @1967 N15_2092 $char8.  @; label N15_2092 ='2092_Date Case Completed--CoC';   /*Revised*/
input @1975 N15_2100 $char8.  @; label N15_2100 ='2100_Date Case Last Changed';  /*Revised*/
input @1983 N15_2110 $char8.  @; label N15_2110 ='2110_Date Case Report Exported';  
input @1991 N15_2111 $char8.  @; label N15_2111 ='2111_Date Case Report Received';  
input @1999 N15_2112 $char8.  @; label N15_2112 ='2112_Date Case Report Loaded'; 
input @2007 N15_2113 $char8.  @; label N15_2113 ='2113_Date Tumor Record Availbl';  
input @2015 N15_2116 $char1.  @; label N15_2116 ='2116_ICD-O-3 Conversion Flag'; 
input @2016 N15_3750 $char1.  @; label N15_3750 ='3750_Over-ride CS 1'; 
input @2017 N15_3751 $char1.  @; label N15_3751 ='3751_Over-ride CS 2'; 
input @2018 N15_3752 $char1.  @; label N15_3752 ='3752_Over-ride CS 3'; 
input @2019 N15_3753 $char1.  @; label N15_3753 ='3753_Over-ride CS 4'; 
input @2020 N15_3754 $char1.  @; label N15_3754 ='3754_Over-ride CS 5'; 
input @2021 N15_3755 $char1.  @; label N15_3755 ='3755_Over-ride CS 6'; 
input @2022 N15_3756 $char1.  @; label N15_3756 ='3756_Over-ride CS 7'; 
input @2023 N15_3757 $char1.  @; label N15_3757 ='3757_Over-ride CS 8'; 
input @2024 N15_3758 $char1.  @; label N15_3758 ='3758_Over-ride CS 9'; 
input @2025 N15_3759 $char1.  @; label N15_3759 ='3759_Over-ride CS 10';   
input @2026 N15_3760 $char1.  @; label N15_3760 ='3760_Over-ride CS 11';   
input @2027 N15_3761 $char1.  @; label N15_3761 ='3761_Over-ride CS 12';   
input @2028 N15_3762 $char1.  @; label N15_3762 ='3762_Over-ride CS 13';   
input @2029 N15_3763 $char1.  @; label N15_3763 ='3763_Over-ride CS 14';   
input @2030 N15_3764 $char1.  @; label N15_3764 ='3764_Over-ride CS 15';   
input @2031 N15_3765 $char1.  @; label N15_3765 ='3765_Over-ride CS 16';   
input @2032 N15_3766 $char1.  @; label N15_3766 ='3766_Over-ride CS 17';   
input @2033 N15_3767 $char1.  @; label N15_3767 ='3767_Over-ride CS 18';   
input @2034 N15_3768 $char1.  @; label N15_3768 ='3768_Over-ride CS 19';   
input @2035 N15_3769 $char1.  @; label N15_3769 ='3769_Over-ride CS 20';   
*input   @2036 N15_1650 $char80. @; *label   N15_1650 ='1650_Reserved 08'; 
input @2116 N15_1750 $char8.  @; label N15_1750 ='1750_Date of Last Contact'; 
input @2124 N15_1751 $char2.  @; label N15_1751 ='1751_Date of Last Contact Flag';  
input @2126 N15_1760 $char1.  @; label N15_1760 ='1760_Vital Status';   
input @2127 N15_1770 $char1.  @; label N15_1770 ='1770_Cancer Status';  
input @2128 N15_1780 $char1.  @; label N15_1780 ='1780_Quality of Survival';  
input @2129 N15_1790 $char1.  @; label N15_1790 ='1790_Follow-Up Source';  
input @2130 N15_1800 $char1.  @; label N15_1800 ='1800_Next Follow-Up Source';   
input @2131 N15_1810 $char50. @; label N15_1810 ='1810_Addr Current--City';   
input @2181 N15_1820 $char2.  @; label N15_1820 ='1820_Addr Current--State';  
input @2183 N15_1830 $char9.  @; label N15_1830 ='1830_Addr Current--Postal Code';  
input @2192 N15_1840 $char3.  @; label N15_1840 ='1840_County--Current';   
*input   @2195 N15_2700 $char1.  @; *label   N15_2700 ='2700_Reserved 17'; 
input @2196 N15_1860 $char8.  @; label N15_1860 ='1860_Recurrence Date--1st'; 
input @2204 N15_1861 $char2.  @; label N15_1861 ='1861_Recurrence Date--1st Flag';  
input @2206 N15_1880 $char2.  @; label N15_1880 ='1880_Recurrence Type--1st'; 
input @2208 N15_1842 $char50. @; label N15_1842 ='1842_Follow-Up Contact--City'; 
input @2258 N15_1844 $char2.  @; label N15_1844 ='1844_Follow-Up Contact--State';   
input @2260 N15_1846 $char9.  @; label N15_1846 ='1846_Follow-Up Contact--Postal';  
input @2269 N15_1910 $char4.  @; label N15_1910 ='1910_Cause of Death'; 
input @2273 N15_1920 $char1.  @; label N15_1920 ='1920_ICD Revision Number';  
input @2274 N15_1930 $char1.  @; label N15_1930 ='1930_Autopsy';  
input @2275 N15_1940 $char3.  @; label N15_1940 ='1940_Place of Death'; 
input @2278 N15_1791 $char2.  @; label N15_1791 ='1791_Follow-up Source Central';   
input @2280 N15_1755 $char8.  @; label N15_1755 ='1755_Date of Death--Canada';   
input @2288 N15_1756 $char2.  @; label N15_1756 ='1756_Date of Death--CanadaFlag';  
input @2290 N15_1850 $char2.  @; label N15_1850 ='1850_Unusual Follow-Up Method';   
input @2292 N15_1782 $char8.  @; label N15_1782 ='1782_Surv-Date Active Followup';  /*New*/
input @2300 N15_1783 $char1.  @; label N15_1783 ='1783_Surv-Flag Active Followup';  /*New*/
input @2301 N15_1784 $char4.  @; label N15_1784 ='1784_Surv-Mos Active Followup';   /*New*/
input @2305 N15_1785 $char8.  @; label N15_1785 ='1785_Surv-Date Presumed Alive';   /*New*/
input @2313 N15_1786 $char1.  @; label N15_1786 ='1786_Surv-Flag Presumed Alive';   /*New*/
input @2314 N15_1787 $char4.  @; label N15_1787 ='1787_Surv-Mos Presumed Alive'; /*New*/
input @2318 N15_1788 $char8.  @; label N15_1788 ='1788_Surv-Date DX Recode';  /*New*/
*input   @2326 N15_1740 $char14. @; *label   N15_1740 ='1740_Reserved 09'; 
  
                        
/* CONFIDENTIAL LAYOUT 5564 */                        
input @3340 N15_2230 $char40. @; label N15_2230 ='2230_Name--Last';  
input @3380 N15_2240 $char40. @; label N15_2240 ='2240_Name--First'; 
input @3420 N15_2250 $char40. @; label N15_2250 ='2250_Name--Middle';   
input @3460 N15_2260 $char3.  @; label N15_2260 ='2260_Name--Prefix';   
input @3463 N15_2270 $char3.  @; label N15_2270 ='2270_Name--Suffix';   
input @3466 N15_2280 $char40. @; label N15_2280 ='2280_Name--Alias'; 
input @3506 N15_2390 $char40. @; label N15_2390 ='2390_Name--Maiden';   
input @3546 N15_2290 $char60. @; label N15_2290 ='2290_Name--Spouse/Parent';  
input @3606 N15_2300 $char11. @; label N15_2300 ='2300_Medical Record Number';   
input @3617 N15_2310 $char2.  @; label N15_2310 ='2310_Military Record No Suffix';  
input @3619 N15_2320 $char9.  @; label N15_2320 ='2320_Social Security Number';  
input @3628 N15_2330 $char60. @; label N15_2330 ='2330_Addr at DX--No & Street'; 
input @3688 N15_2335 $char60. @; label N15_2335 ='2335_Addr at DX--Supplementl'; 
input @3748 N15_2350 $char60. @; label N15_2350 ='2350_Addr Current--No & Street';  
input @3808 N15_2355 $char60. @; label N15_2355 ='2355_Addr Current--Supplementl';  
input @3868 N15_2360 $char10. @; label N15_2360 ='2360_Telephone';   
input @3878 N15_2380 $char6.  @; label N15_2380 ='2380_DC State File Number'; 
input @3884 N15_2394 $char60. @; label N15_2394 ='2394_Follow-Up Contact--Name'; 
input @3944 N15_2392 $char60. @; label N15_2392 ='2392_Follow-Up Contact--No&St';   
input @4004 N15_2393 $char60. @; label N15_2393 ='2393_Follow-Up Contact--Suppl';   
input @4064 N15_2352 $char10. @; label N15_2352 ='2352_Latitude'; 
input @4074 N15_2354 $char11. @; label N15_2354 ='2354_Longitude';   
*input   @4085 N15_1835 $char200.   @; *label   N15_1835 ='1835_Reserved 10'; 
input @4285 N15_2445 $char10. @; label N15_2445 ='2445_NPI--Following Registry'; 
input @4295 N15_2440 $char10. @; label N15_2440 ='2440_Following Registry';   
input @4305 N15_2415 $char10. @; label N15_2415 ='2415_NPI--Inst Referred From'; 
input @4315 N15_2410 $char10. @; label N15_2410 ='2410_Institution Referred From';  
input @4325 N15_2425 $char10. @; label N15_2425 ='2425_NPI--Inst Referred To';   
input @4335 N15_2420 $char10. @; label N15_2420 ='2420_Institution Referred To'; 
*input   @4345 N15_1900 $char50. @; *label   N15_1900 ='1900_Reserved 11'; 
input @4395 N15_2465 $char10. @; label N15_2465 ='2465_NPI--Physician--Managing';   
input @4405 N15_2460 $char8.  @; label N15_2460 ='2460_Physician--Managing';  
input @4413 N15_2475 $char10. @; label N15_2475 ='2475_NPI--Physician--Follow-Up';  
input @4423 N15_2470 $char8.  @; label N15_2470 ='2470_Physician--Follow-Up'; 
input @4431 N15_2485 $char10. @; label N15_2485 ='2485_NPI--Physician--Primary Surg';  
input @4441 N15_2480 $char8.  @; label N15_2480 ='2480_Physician--Primary Surg'; 
input @4449 N15_2495 $char10. @; label N15_2495 ='2495_NPI--Physician 3';  
input @4459 N15_2490 $char8.  @; label N15_2490 ='2490_Physician 3'; 
input @4467 N15_2505 $char10. @; label N15_2505 ='2505_NPI--Physician 4';  
input @4477 N15_2500 $char8.  @; label N15_2500 ='2500_Physician 4'; 
input @4535 N15_7010 $char25. @; label N15_7010 ='7010_Path Reporting Fac ID 1'; 
input @4560 N15_7090 $char20. @; label N15_7090 ='7090_Path Report Number 1'; 
input @4580 N15_7320 $char14. @; label N15_7320 ='7320_Path Date Spec Collect 1';   
input @4594 N15_7480 $char2.  @; label N15_7480 ='7480_Path Report Type 1';   
input @4596 N15_7190 $char25. @; label N15_7190 ='7190_Path Ordering Fac No 1';  
input @4621 N15_7100 $char20. @; label N15_7100 ='7100_Path Order Phys Lic No 1';   
input @4641 N15_7011 $char25. @; label N15_7011 ='7011_Path Reporting Fac ID 2'; 
input @4666 N15_7091 $char20. @; label N15_7091 ='7091_Path Report Number 2'; 
input @4686 N15_7321 $char14. @; label N15_7321 ='7321_Path Date Spec Collect 2';   
input @4700 N15_7481 $char2.  @; label N15_7481 ='7481_Path Report Type 2';   
input @4702 N15_7191 $char25. @; label N15_7191 ='7191_Path Ordering Fac No 2';  
input @4727 N15_7101 $char20. @; label N15_7101 ='7101_Path Order Phys Lic No 2';   
input @4747 N15_7012 $char25. @; label N15_7012 ='7012_Path Reporting Fac ID 3'; 
input @4772 N15_7092 $char20. @; label N15_7092 ='7092_Path Report Number 3'; 
input @4792 N15_7322 $char14. @; label N15_7322 ='7322_Path Date Spec Collect 3';   
input @4806 N15_7482 $char2.  @; label N15_7482 ='7482_Path Report Type 3';   
input @4808 N15_7192 $char25. @; label N15_7192 ='7192_Path Ordering Fac No 3';  
input @4833 N15_7102 $char20. @; label N15_7102 ='7102_Path Order Phys Lic No 3';   
input @4853 N15_7013 $char25. @; label N15_7013 ='7013_Path Reporting Fac ID 4'; 
input @4878 N15_7093 $char20. @; label N15_7093 ='7093_Path Report Number 4'; 
input @4898 N15_7323 $char14. @; label N15_7323 ='7323_Path Date Spec Collect 4';   
input @4912 N15_7483 $char2.  @; label N15_7483 ='7483_Path Report Type 4';   
input @4914 N15_7193 $char25. @; label N15_7193 ='7193_Path Ordering Fac No 4';  
input @4939 N15_7103 $char20. @; label N15_7103 ='7103_Path Order Phys Lic No 4';   
input @4959 N15_7014 $char25. @; label N15_7014 ='7014_Path Reporting Fac ID 5'; 
input @4984 N15_7094 $char20. @; label N15_7094 ='7094_Path Report Number 5'; 
input @5004 N15_7324 $char14. @; label N15_7324 ='7324_Path Date Spec Collect 5';   
input @5018 N15_7484 $char2.  @; label N15_7484 ='7484_Path Report Type 5';   
input @5020 N15_7194 $char25. @; label N15_7194 ='7194_Path Ordering Fac No 5';  
input @5045 N15_7104 $char20. @; label N15_7104 ='7104_Path Order Phys Lic No 5';   
*input   @5065 N15_2080 $char500.   @; *label   N15_2080 ='2080_Reserved 13'; 


/* NPCR CER & PCOR VARIABLES - ONLY FOR CER & PCOR STATES */
input @5065 N15_8000 $char8.  @; label N15_8000 ='8000_Active Follow-Up Date';   
input @5073 N15_8002 $char8.  @; label N15_8002 ='8002_Comp1stCrsRxDt'; 
input @5081 N15_8005 $char8.  @; label N15_8005 ='8005_FrstDsFreeDt';   
input @5089 N15_8008 $char8.  @; label N15_8008 ='8008_LstDsFreeDt'; 
input @5097 N15_8011 $char8.  @; label N15_8011 ='8011_FrstRecDt';   
input @5105 N15_8015 $char8.  @; label N15_8015 ='8015_ProgressionDt';  
input @5113 N15_8018 $char8.  @; label N15_8018 ='8018_SubseqPrmryDt';  
input @5121 N15_8020 $char8.  @; label N15_8020 ='8020_PCOR_SubseqRx2ndCrsDt';   
input @5129 N15_8021 $char2.  @; label N15_8021 ='8021_PCOR_SubseqRx2ndCrsDtFlag';  
input @5133 N15_9751 $char6.  @; label N15_9751 ='9751_Chemo 1 NSC Number';   
input @5139 N15_9761 $char2.  @; label N15_9761 ='9761_Chemo 1 Num Doses Planned';  
input @5141 N15_9771 $char6.  @; label N15_9771 ='9771_Chemo 1 Planned Dose'; 
input @5147 N15_9781 $char2.  @; label N15_9781 ='9781_Chemo 1 Planned Dose Unit';  
input @5149 N15_9791 $char2.  @; label N15_9791 ='9791_Chemo 1 Num Doses Receivd';  
input @5151 N15_9801 $char6.  @; label N15_9801 ='9801_Chemo 1 Received Dose';   
input @5157 N15_9811 $char2.  @; label N15_9811 ='9811_Chemo 1 Received DoseUnit';  
input @5159 N15_9821 $char8.  @; label N15_9821 ='9821_Chemo 1 Start Date';   
input @5167 N15_9831 $char2.  @; label N15_9831 ='9831_Chemo 1 Start Date Flag'; 
input @5169 N15_9841 $char8.  @; label N15_9841 ='9841_Chemo 1 End Date';  
input @5177 N15_9851 $char2.  @; label N15_9851 ='9851_Chemo 1 End Date Flag';   
input @5179 N15_9752 $char6.  @; label N15_9752 ='9752_Chemo 2 NSC Number';   
input @5185 N15_9762 $char2.  @; label N15_9762 ='9762_Chemo 2 Num Doses Planned';  
input @5187 N15_9772 $char6.  @; label N15_9772 ='9772_Chemo 2 Planned Dose'; 
input @5193 N15_9782 $char2.  @; label N15_9782 ='9782_Chemo 2 Planned Dose Unit';  
input @5195 N15_9792 $char2.  @; label N15_9792 ='9792_Chemo 2 Num Doses Receivd';  
input @5197 N15_9802 $char6.  @; label N15_9802 ='9802_Chemo 2 Received Dose';   
input @5203 N15_9812 $char2.  @; label N15_9812 ='9812_Chemo 2 Received DoseUnit';  
input @5205 N15_9822 $char8.  @; label N15_9822 ='9822_Chemo 2 Start Date';   
input @5213 N15_9832 $char2.  @; label N15_9832 ='9832_Chemo 2 Start Date Flag'; 
input @5215 N15_9842 $char8.  @; label N15_9842 ='9842_Chemo 2 End Date';  
input @5223 N15_9852 $char2.  @; label N15_9852 ='9852_Chemo 2 End Date Flag';   
input @5225 N15_9900 $char3.  @; label N15_9900 ='9900_BCR-ABL Cytogenetic';  
input @5228 N15_9901 $char8.  @; label N15_9901 ='9901_BCR-ABL Cytogenetic Date';   
input @5236 N15_9902 $char2.  @; label N15_9902 ='9902_BCR-ABL Cytogen Date Flag';  
input @5238 N15_9903 $char3.  @; label N15_9903 ='9903_BCR-ABL FISH';   
input @5241 N15_9904 $char8.  @; label N15_9904 ='9904_BCR-ABL FISH Date'; 
input @5249 N15_9905 $char2.  @; label N15_9905 ='9905_BCR-ABL FISH Date Flag';  
input @5251 N15_9906 $char3.  @; label N15_9906 ='9906_BCR-ABL RT-PCR Qual';  
input @5254 N15_9907 $char8.  @; label N15_9907 ='9907_BCR-ABL RT-PCR Qual Date';   
input @5262 N15_9908 $char2.  @; label N15_9908 ='9908_BCR-ABL RT-PCR Qual DtFlg';  
input @5264 N15_9909 $char3.  @; label N15_9909 ='9909_BCR-ABL RT-PCR Quant'; 
input @5267 N15_9910 $char8.  @; label N15_9910 ='9910_BCR-ABL RT-PCR Quant Date';  
input @5275 N15_9911 $char2.  @; label N15_9911 ='9911_BCR-ABL RT-PCR Quan DtFlg';  
input @5277 N15_9753 $char6.  @; label N15_9753 ='9753_Chemo 3 NSC Number';   
input @5283 N15_9763 $char2.  @; label N15_9763 ='9763_Chemo 3 Num Doses Planned';  
input @5285 N15_9773 $char6.  @; label N15_9773 ='9773_Chemo 3 Planned Dose'; 
input @5291 N15_9783 $char2.  @; label N15_9783 ='9783_Chemo 3 Planned Dose Unit';  
input @5293 N15_9793 $char2.  @; label N15_9793 ='9793_Chemo 3 Num Doses Receivd';  
input @5295 N15_9803 $char6.  @; label N15_9803 ='9803_Chemo 3 Received Dose';   
input @5301 N15_9813 $char2.  @; label N15_9813 ='9813_Chemo 3 Received DoseUnit';  
input @5303 N15_9823 $char8.  @; label N15_9823 ='9823_Chemo 3 Start Date';   
input @5311 N15_9833 $char2.  @; label N15_9833 ='9833_Chemo 3 Start Date Flag'; 
input @5313 N15_9843 $char8.  @; label N15_9843 ='9843_Chemo 3 End Date';  
input @5321 N15_9853 $char2.  @; label N15_9853 ='9853_Chemo 3 End Date Flag';   
input @5323 N15_9754 $char6.  @; label N15_9754 ='9754_Chemo 4 NSC Number';   
input @5329 N15_9764 $char2.  @; label N15_9764 ='9764_Chemo 4 Num Doses Planned';  
input @5331 N15_9774 $char6.  @; label N15_9774 ='9774_Chemo 4 Planned Dose'; 
input @5337 N15_9784 $char2.  @; label N15_9784 ='9784_Chemo 4 Planned Dose Unit';  
input @5339 N15_9794 $char2.  @; label N15_9794 ='9794_Chemo 4 Num Doses Receivd';  
input @5341 N15_9804 $char6.  @; label N15_9804 ='9804_Chemo 4 Received Dose';   
input @5347 N15_9814 $char2.  @; label N15_9814 ='9814_Chemo 4 Received DoseUnit';  
input @5349 N15_9824 $char8.  @; label N15_9824 ='9824_Chemo 4 Start Date';   
input @5357 N15_9834 $char2.  @; label N15_9834 ='9834_Chemo 4 Start Date Flag'; 
input @5359 N15_9844 $char8.  @; label N15_9844 ='9844_Chemo 4 End Date';  
input @5367 N15_9854 $char2.  @; label N15_9854 ='9854_Chemo 4 End Date Flag';   
input @5369 N15_9755 $char6.  @; label N15_9755 ='9755_Chemo 5 NSC Number';   
input @5375 N15_9765 $char2.  @; label N15_9765 ='9765_Chemo 5 Num Doses Planned';  
input @5377 N15_9775 $char6.  @; label N15_9775 ='9775_Chemo 5 Planned Dose'; 
input @5383 N15_9785 $char2.  @; label N15_9785 ='9785_Chemo 5 Planned Dose Unit';  
input @5385 N15_9795 $char2.  @; label N15_9795 ='9795_Chemo 5 Num Doses Receivd';  
input @5387 N15_9805 $char6.  @; label N15_9805 ='9805_Chemo 5 Received Dose';   
input @5393 N15_9815 $char2.  @; label N15_9815 ='9815_Chemo 5 Received DoseUnit';  
input @5395 N15_9825 $char8.  @; label N15_9825 ='9825_Chemo 5 Start Date';   
input @5403 N15_9835 $char2.  @; label N15_9835 ='9835_Chemo 5 Start Date Flag'; 
input @5405 N15_9845 $char8.  @; label N15_9845 ='9845_Chemo 5 End Date';  
input @5413 N15_9855 $char2.  @; label N15_9855 ='9855_Chemo 5 End Date Flag';   
input @5415 N15_9756 $char6.  @; label N15_9756 ='9756_Chemo 6 NSC Number';   
input @5421 N15_9766 $char2.  @; label N15_9766 ='9766_Chemo 6 Num Doses Planned';  
input @5423 N15_9776 $char6.  @; label N15_9776 ='9776_Chemo 6 Planned Dose'; 
input @5429 N15_9786 $char2.  @; label N15_9786 ='9786_Chemo 6 Planned Dose Unit';  
input @5431 N15_9796 $char2.  @; label N15_9796 ='9796_Chemo 6 Num Doses Receivd';  
input @5433 N15_9806 $char6.  @; label N15_9806 ='9806_Chemo 6 Received Dose';   
input @5439 N15_9816 $char2.  @; label N15_9816 ='9816_Chemo 6 Received DoseUnit';  
input @5441 N15_9826 $char8.  @; label N15_9826 ='9826_Chemo 6 Start Date';   
input @5449 N15_9836 $char2.  @; label N15_9836 ='9836_Chemo 6 Start Date Flag'; 
input @5451 N15_9846 $char8.  @; label N15_9846 ='9846_Chemo 6 End Date';  
input @5459 N15_9856 $char2.  @; label N15_9856 ='9856_Chemo 6 End Date Flag';   
input @5461 N15_9859 $char1.  @; label N15_9859 ='9859_Chemo Completion Status'; 
input @5462 N15_9920 $char1.  @; label N15_9920 ='9920_Reason Subsq Rx';   
input @5463 N15_9921 $char2.  @; label N15_9921 ='9921_Subsq RX 2ndCrs Surg'; 
input @5465 N15_9922 $char2.  @; label N15_9922 ='9922_Subsq Rx 2ndCrs Rad';  
input @5467 N15_9923 $char2.  @; label N15_9923 ='9923_Subsq Rx 2ndCrs Chemo';   
input @5469 N15_9924 $char2.  @; label N15_9924 ='9924_Subsq Rx 2ndCrs Horm'; 
input @5471 N15_9925 $char2.  @; label N15_9925 ='9925_Subsq Rx 2ndCrs BRM';  
input @5473 N15_9926 $char1.  @; label N15_9926 ='9926_Subsq Rx 2ndCrs Oth';  
input @5474 N15_9927 $char2.  @; label N15_9927 ='9927_Subsq Rx 2ndCrs Trans/End';  
input @5476 N15_9931 $char6.  @; label N15_9931 ='9931_Subsq RX 2nd Chemo 1 NSC';   
input @5482 N15_9932 $char6.  @; label N15_9932 ='9932_Subsq RX 2nd Chemo 2 NSC';   
input @5488 N15_9933 $char6.  @; label N15_9933 ='9933_Subsq RX 2nd Chemo 3 NSC';   
input @5494 N15_9934 $char6.  @; label N15_9934 ='9934_Subsq RX 2nd Chemo 4 NSC';   
input @5500 N15_9935 $char6.  @; label N15_9935 ='9935_Subsq RX 2nd Chemo 5 NSC';   
input @5506 N15_9936 $char6.  @; label N15_9936 ='9936_Subsq RX 2nd Chemo 6 NSC';   
input @5512 N15_9941 $char6.  @; label N15_9941 ='9941_Subsq RX 2nd Horm 1 NSC'; 
input @5518 N15_9942 $char6.  @; label N15_9942 ='9942_Subsq RX 2nd Horm 2 NSC'; 
input @5524 N15_9951 $char6.  @; label N15_9951 ='9951_Subsq RX 2nd BRM 1 NSC';  
input @5530 N15_9952 $char6.  @; label N15_9952 ='9952_Subsq RX 2nd BRM 2 NSC';  
input @5536 N15_9955 $char2.  @; label N15_9955 ='9955_Subsq RX 2nd DateFlag CER';  
input @5538 N15_9861 $char6.  @; label N15_9861 ='9861_Hormone 1 NSC Number'; 
input @5544 N15_9862 $char6.  @; label N15_9862 ='9862_Hormone 2 NSC Number'; 
input @5550 N15_9871 $char6.  @; label N15_9871 ='9871_BRM 1 NSC';   
input @5556 N15_9872 $char6.  @; label N15_9872 ='9872_BRM 2 NSC';   
input @5562 N15_9880 $char1.  @; label N15_9880 ='9880_Granulocyte CSF Status';  
input @5563 N15_9881 $char1.  @; label N15_9881 ='9881_Erythro Growth Factor Sta';  
input @5564 N15_9882 $char1.  @; label N15_9882 ='9882_Thrombocyte GrowthFactSta';  
                        
                        
/* TEXT VARIABLES 22824 */                         
input @5565    N15_2520 $char1000.  @; label N15_2520 ='2520_Text--DX Proc--PE'; 
input @6565    N15_2530 $char1000.  @; label N15_2530 ='2530_Text--DX Proc--X-ray/scan';  
input @7565    N15_2540 $char1000.  @; label N15_2540 ='2540_Text--DX Proc--Scopes';   
input @8565    N15_2550 $char1000.  @; label N15_2550 ='2550_Text--DX Proc--Lab Tests';   
input @9565    N15_2560 $char1000.  @; label N15_2560 ='2560_Text--DX Proc--Op'; 
input @10565   N15_2570 $char1000.  @; label N15_2570 ='2570_Text--DX Proc--Path';  
input @11565   N15_2580 $char100.   @; label N15_2580 ='2580_Text--Primary Site Title';   
input @11665   N15_2590 $char100.   @; label N15_2590 ='2590_Text--Histology Title';   
input @11765   N15_2600 $char1000.  @; label N15_2600 ='2600_Text--Staging';  
input @12765   N15_2610 $char1000.  @; label N15_2610 ='2610_RX Text--Surgery';  
input @13765   N15_2620 $char1000.  @; label N15_2620 ='2620_RX Text--Radiation (Beam)';  
input @14765   N15_2630 $char1000.  @; label N15_2630 ='2630_RX Text--Radiation Other';   
input @15765   N15_2640 $char1000.  @; label N15_2640 ='2640_RX Text--Chemo'; 
input @16765   N15_2650 $char1000.  @; label N15_2650 ='2650_RX Text--Hormone';  
input @17765   N15_2660 $char1000.  @; label N15_2660 ='2660_RX Text--BRM';   
input @18765   N15_2670 $char1000.  @; label N15_2670 ='2670_RX Text--Other'; 
input @19765   N15_2680 $char1000.  @; label N15_2680 ='2680_Text--Remarks';  
input @20765   N15_2690 $char60.    @; label N15_2690 ='2690_Text--Place Of Diagnosis';   
*input   @20825   N15_2210 $char2000.  @; *label   N15_2210 ='2210_Reserved 14'; 
                        

/* ADDITIONAL USEFUL VARIABLES IN RECORD */
input @530 dx_year    $char4.   @;  label  dx_year   ='YEAR OF DIAGNOSIS';
input @534 dx_month   $char2.   @;  label  dx_month  ='MONTH OF DIAGNOSIS';
input @147 ZIPCode    $char5.   @;  label  ZIPCode   ='ZIP CODE 5-DIGIT';  

run;



data _NULL_;
   set SAStest;
* file outv15 lrecl= 3339 pad; /* INCIDENCE */
* file outv15 lrecl= 5564 pad; /* CONFIDENTIAL */
  file outv15 lrecl=22824 pad; /* TEXT */
put
/* Incidence record */              
   @  1     N15_10   $1.   
   @  2     N15_30   $1.   
/* @  3     N15_37   $14.  */
   @  17    N15_50   $3.   
   @  20    N15_45   $10.  
   @  30    N15_40   $10.  
   @  40    N15_60   $2.   
   @  42    N15_20   $8.   
   @  50    N15_21   $8.   
/* @  58  N15_370 $37.  */
   @  95    N15_70   $50.  
   @  145   N15_80   $2.   
   @  147   N15_100  $9.   
   @  156   N15_90   $3.   
   @  159   N15_110  $6.   
   @  165   N15_368  $1.   
   @  166   N15_120  $1.   
   @  167   N15_364  $1.   
   @  168   N15_130  $6.   
   @  174   N15_362  $1.   
   @  175   N15_365  $1.   
   @  176   N15_150  $1.   
   @  177   N15_160  $2.   
   @  179   N15_161  $2.   
   @  181   N15_162  $2.   
   @  183   N15_163  $2.   
   @  185   N15_164  $2.   
   @  187   N15_170  $1.   
   @  188   N15_180  $1.   
   @  189   N15_190  $1.   
   @  190   N15_200  $1.   
   @  191   N15_210  $1.   
   @  192   N15_220  $1.   
   @  193   N15_230  $3.   
   @  196   N15_240  $8.   
   @  204   N15_241  $2.   
   @  206   N15_250  $3.   
   @  209   N15_270  $3.   
   @  212   N15_280  $3.   
   @  215   N15_290  $1.   
   @  216   N15_300  $1.   
   @  217   N15_310  $100. 
   @  317   N15_320  $100. 
   @  417   N15_330  $1.   
   @  418   N15_191  $1.   
   @  419   N15_193  $2.   
   @  421   N15_192  $1.   
   @  422   N15_366  $2.   
   @  424   N15_3300 $2.   
   @  426   N15_3310 $2.   
   @  428   N15_135  $6.   
   @  434   N15_363  $1.   
   @  435   N15_367  $1.   
   @  436   N15_102  $3.   
   @  439   N15_1832 $3.   
   @  442   N15_252  $2.   
   @  444   N15_254  $3.   
   @  447   N15_1847 $3.   
   @  450   N15_1942 $2.   
   @  452   N15_1944 $3.   
   @  455   N15_272  $4.   
   @  459   N15_282  $4.   
   @  463   N15_145  $1.   
/* @  464   N15_530  $64.  */
   @  528   N15_380  $2.   
   @  530   N15_390  $8.   
   @  538   N15_391  $2.   
   @  540   N15_400  $4.   
   @  544   N15_410  $1.   
   @  545   N15_419  $5.   
   @  545   N15_420  $4.   
   @  549   N15_430  $1.   
   @  550   N15_521  $5.   
   @  550   N15_522  $4.   
   @  554   N15_523  $1.   
   @  555   N15_440  $1.   
   @  556   N15_441  $1.   
   @  557   N15_449  $1.   
   @  558   N15_450  $1.   
   @  559   N15_460  $1.   
   @  560   N15_470  $1.   
   @  561   N15_480  $1.   
   @  562   N15_490  $1.   
   @  563   N15_500  $1.   
   @  564   N15_501  $2.   
   @  566   N15_442  $1.   
   @  567   N15_443  $8.   
   @  575   N15_448  $2.   
   @  577   N15_444  $2.   
   @  579   N15_445  $8.   
   @  587   N15_439  $2.   
   @  589   N15_446  $2.   
/* @  591   N15_680  $100. */
   @  691   N15_545  $10.  
   @  701   N15_540  $10.  
   @  711   N15_3105 $10.  
   @  721   N15_3100 $10.  
   @  731   N15_550  $9.   
   @  740   N15_560  $2.   
   @  742   N15_570  $3.   
   @  745   N15_580  $8.   
   @  753   N15_581  $2.   
   @  755   N15_590  $8.   
   @  763   N15_591  $2.   
   @  765   N15_600  $8.   
   @  773   N15_601  $2.   
   @  775   N15_605  $1.   
   @  776   N15_610  $2.   
   @  778   N15_630  $2.   
/* @  780   N15_2400 $1.   */
   @  781   N15_668  $1.   
   @  782   N15_670  $2.   
   @  784   N15_672  $1.   
   @  785   N15_674  $1.   
   @  786   N15_676  $2.   
/* @  788   N15_2450 $1.   */
   @  789   N15_690  $1.   
   @  790   N15_700  $2.   
   @  792   N15_710  $2.   
   @  794   N15_720  $2.   
   @  796   N15_730  $1.   
   @  797   N15_740  $2.   
   @  799   N15_3280 $1.   
   @  800   N15_746  $2.   
   @  802   N15_747  $1.   
   @  803   N15_748  $1.   
/* @  804   N15_750  $100. */
   @  904   N15_759  $1.   
   @  905   N15_760  $1.   
   @  906   N15_779  $12.  
   @  906   N15_780  $3.   
   @  909   N15_790  $2.   
   @  911   N15_800  $2.   
   @  913   N15_810  $1.   
   @  914   N15_820  $2.   
   @  916   N15_830  $2.   
   @  918   N15_840  $13.  
   @  931   N15_850  $2.   
   @  933   N15_860  $4.   
   @  937   N15_870  $1.   
   @  938   N15_1060 $2.   
   @  940   N15_880  $4.   
   @  944   N15_890  $4.   
   @  948   N15_900  $4.   
   @  952   N15_910  $4.   
   @  956   N15_920  $1.   
   @  957   N15_930  $1.   
   @  958   N15_940  $4.   
   @  962   N15_950  $4.   
   @  966   N15_960  $4.   
   @  970   N15_970  $4.   
   @  974   N15_980  $1.   
   @  975   N15_990  $1.   
   @  976   N15_1120 $2.   
   @  978   N15_1130 $2.   
   @  980   N15_1140 $1.   
   @  981   N15_1150 $1.   
   @  982   N15_1160 $1.   
   @  983   N15_1170 $1.   
   @  984   N15_1182 $1.   
   @  985   N15_2800 $3.   
   @  988   N15_2810 $3.   
   @  991   N15_2820 $1.   
   @  992   N15_2830 $3.   
   @  995   N15_2840 $1.   
   @  996   N15_2850 $2.   
   @  998   N15_2860 $1.   
   @  999   N15_2851 $1.   
   @  1000  N15_2852 $1.   
   @  1001  N15_2853 $1.   
   @  1002  N15_2854 $1.   
   @  1003  N15_2880 $3.   
   @  1006  N15_2890 $3.   
   @  1009  N15_2900 $3.   
   @  1012  N15_2910 $3.   
   @  1015  N15_2920 $3.   
   @  1018  N15_2930 $3.   
   @  1021  N15_2861 $3.   
   @  1024  N15_2862 $3.   
   @  1027  N15_2863 $3.   
   @  1030  N15_2864 $3.   
   @  1033  N15_2865 $3.   
   @  1036  N15_2866 $3.   
   @  1039  N15_2867 $3.   
   @  1042  N15_2868 $3.   
   @  1045  N15_2869 $3.   
   @  1048  N15_2870 $3.   
   @  1051  N15_2871 $3.   
   @  1054  N15_2872 $3.   
   @  1057  N15_2873 $3.   
   @  1060  N15_2874 $3.   
   @  1063  N15_2875 $3.   
   @  1066  N15_2876 $3.   
   @  1069  N15_2877 $3.   
   @  1072  N15_2878 $3.   
   @  1075  N15_2879 $3.   
   @  1078  N15_2730 $3.   
   @  1081  N15_2735 $3.   
   @  1084  N15_2740 $1.   
   @  1085  N15_2750 $3.   
   @  1088  N15_2755 $1.   
   @  1089  N15_2760 $2.   
   @  1091  N15_2765 $1.   
   @  1092  N15_2770 $3.   
   @  1095  N15_2775 $3.   
   @  1098  N15_2780 $3.   
   @  1101  N15_2785 $2.   
   @  1103  N15_2940 $2.   
   @  1105  N15_2950 $1.   
   @  1106  N15_2960 $2.   
   @  1108  N15_2970 $1.   
   @  1109  N15_2980 $2.   
   @  1111  N15_2990 $1.   
   @  1112  N15_3000 $2.   
   @  1114  N15_3400 $3.   
   @  1117  N15_3402 $1.   
   @  1118  N15_3410 $3.   
   @  1121  N15_3412 $1.   
   @  1122  N15_3420 $3.   
   @  1125  N15_3422 $1.   
   @  1126  N15_3430 $3.   
   @  1129  N15_3440 $3.   
   @  1132  N15_3442 $1.   
   @  1133  N15_3450 $3.   
   @  1136  N15_3452 $1.   
   @  1137  N15_3460 $3.   
   @  1140  N15_3462 $1.   
   @  1141  N15_3470 $3.   
   @  1144  N15_3480 $3.   
   @  1147  N15_3482 $3.   
   @  1150  N15_3490 $2.   
   @  1152  N15_3492 $3.   
   @  1155  N15_3010 $1.   
   @  1156  N15_3020 $1.   
   @  1157  N15_3600 $1.   
   @  1158  N15_3030 $1.   
   @  1159  N15_3040 $1.   
   @  1160  N15_3050 $1.   
   @  1161  N15_2937 $6.   
   @  1167  N15_2935 $6.   
   @  1173  N15_2936 $6.   
   @  1179  N15_3700 $1.   
   @  1180  N15_3702 $1.   
   @  1181  N15_3704 $1.   
   @  1182  N15_3706 $1.   
   @  1183  N15_3708 $1.   
   @  1184  N15_3710 $1.   
   @  1185  N15_3165 $1.   
   @  1186  N15_3110 $5.   
   @  1191  N15_3120 $5.   
   @  1196  N15_3130 $5.   
   @  1201  N15_3140 $5.   
   @  1206  N15_3150 $5.   
   @  1211  N15_3160 $5.   
   @  1216  N15_3161 $5.   
   @  1221  N15_3162 $5.   
   @  1226  N15_3163 $5.   
   @  1231  N15_3164 $5.   
   @  1236  N15_3780 $7.   
   @  1243  N15_3782 $7.   
   @  1250  N15_3784 $7.   
   @  1257  N15_3786 $7.   
   @  1264  N15_3788 $7.   
   @  1271  N15_3790 $7.   
   @  1278  N15_3792 $7.   
   @  1285  N15_3794 $7.   
   @  1292  N15_3796 $7.   
   @  1299  N15_3798 $7.   
               
/* NPCR-specific fields */             
   @  1306  N15_9980 $1.   
   @  1307  N15_9981 $8.   
   @  1315  N15_9960 $2.   
   @  1317  N15_9961 $3.   
   @  1320  N15_9965 $1.   
   @  1321  N15_9966 $1.   
   @  1322  N15_9967 $1.   
   @  1323  N15_9968 $1.   
   @  1324  N15_9970 $1.   
/* @  1325  N15_3720 $56.  */
               
/* NPCR CER and PCOR fields */               
   @  1325  N15_9969 $1.   
   @  1326  N15_8003 $1.   
   @  1327  N15_8004 $1.   
   @  1328  N15_8006 $1.   
   @  1329  N15_8007 $1.   
   @  1330  N15_8009 $1.   
   @  1331  N15_8010 $1.   
   @  1332  N15_8012 $2.   
   @  1334  N15_8013 $1.   
   @  1335  N15_8014 $1.   
   @  1336  N15_8016 $1.   
   @  1337  N15_8017 $1.   
   @  1338  N15_8019 $1.   
   @  1339  N15_8022 $2.   
   @  1341  N15_8023 $2.   
   @  1343  N15_8024 $2.   
   @  1345  N15_8025 $2.   
   @  1347  N15_8026 $1.   
   @  1348  N15_8001 $1.   
               
/* @  1381  N15_1180 $55.  */
   @  1436  N15_1260 $8.   
   @  1444  N15_1261 $2.   
   @  1446  N15_1270 $8.   
   @  1454  N15_1271 $2.   
   @  1456  N15_1200 $8.   
   @  1464  N15_1201 $2.   
   @  1466  N15_3170 $8.   
   @  1474  N15_3171 $2.   
   @  1476  N15_3180 $8.   
   @  1484  N15_3181 $2.   
   @  1486  N15_1210 $8.   
   @  1494  N15_1211 $2.   
   @  1496  N15_3220 $8.   
   @  1504  N15_3221 $2.   
   @  1506  N15_3230 $8.   
   @  1514  N15_3231 $2.   
   @  1516  N15_1220 $8.   
   @  1524  N15_1221 $2.   
   @  1526  N15_1230 $8.   
   @  1534  N15_1231 $2.   
   @  1536  N15_1240 $8.   
   @  1544  N15_1241 $2.   
   @  1546  N15_1250 $8.   
   @  1554  N15_1251 $2.   
   @  1556  N15_1280 $8.   
   @  1564  N15_1281 $2.   
   @  1566  N15_1285 $1.   
   @  1567  N15_1290 $2.   
   @  1569  N15_1292 $1.   
   @  1570  N15_1294 $1.   
   @  1571  N15_1296 $2.   
   @  1573  N15_1310 $1.   
   @  1574  N15_1320 $1.   
   @  1575  N15_1330 $1.   
   @  1576  N15_1340 $1.   
   @  1577  N15_1350 $2.   
   @  1579  N15_3270 $1.   
   @  1580  N15_1360 $1.   
   @  1581  N15_1370 $1.   
   @  1582  N15_1380 $1.   
   @  1583  N15_3250 $2.   
   @  1585  N15_1390 $2.   
   @  1587  N15_1400 $2.   
   @  1589  N15_1410 $2.   
   @  1591  N15_1420 $1.   
   @  1592  N15_1430 $1.   
   @  1593  N15_1460 $2.   
/* @  1595  N15_2161 $1.   */
   @  1596  N15_1510 $5.   
   @  1601  N15_1520 $3.   
   @  1604  N15_1540 $2.   
   @  1606  N15_1550 $1.   
   @  1607  N15_1570 $2.   
   @  1609  N15_3200 $2.   
   @  1611  N15_3210 $5.   
   @  1616  N15_1639 $1.   
   @  1617  N15_1640 $2.   
   @  1619  N15_3190 $1.   
   @  1620  N15_1646 $2.   
   @  1622  N15_1647 $1.   
   @  1623  N15_1648 $1.   
/* @  1624  N15_1190 $100. */
   @  1724  N15_1660 $8.   
   @  1732  N15_1661 $2.   
   @  1734  N15_1670 $11.  
   @  1734  N15_1671 $2.   
   @  1736  N15_1677 $1.   
   @  1737  N15_1678 $1.   
   @  1738  N15_1679 $2.   
   @  1740  N15_1672 $1.   
   @  1741  N15_1673 $1.   
   @  1742  N15_1674 $1.   
   @  1743  N15_1675 $1.   
   @  1744  N15_1676 $1.   
   @  1745  N15_1680 $8.   
   @  1753  N15_1681 $2.   
   @  1755  N15_1690 $11.  
   @  1755  N15_1691 $2.   
   @  1757  N15_1697 $1.   
   @  1758  N15_1698 $1.   
   @  1759  N15_1699 $2.   
   @  1761  N15_1692 $1.   
   @  1762  N15_1693 $1.   
   @  1763  N15_1694 $1.   
   @  1764  N15_1695 $1.   
   @  1765  N15_1696 $1.   
   @  1766  N15_1700 $8.   
   @  1774  N15_1701 $2.   
   @  1776  N15_1710 $11.  
   @  1776  N15_1711 $2.   
   @  1778  N15_1717 $1.   
   @  1779  N15_1718 $1.   
   @  1780  N15_1719 $2.   
   @  1782  N15_1712 $1.   
   @  1783  N15_1713 $1.   
   @  1784  N15_1714 $1.   
   @  1785  N15_1715 $1.   
   @  1786  N15_1716 $1.   
   @  1787  N15_1741 $1.   
/* @  1788  N15_1300 $100. */
   @  1888  N15_1981 $1.   
   @  1889  N15_1982 $1.   
   @  1890  N15_1983 $1.   
   @  1891  N15_1985 $1.   
   @  1892  N15_1986 $1.   
   @  1893  N15_1987 $1.   
   @  1894  N15_1988 $1.   
   @  1895  N15_1989 $1.   
   @  1896  N15_1990 $1.   
   @  1897  N15_2000 $1.   
   @  1898  N15_2010 $1.   
   @  1899  N15_2020 $1.   
   @  1900  N15_2030 $1.   
   @  1901  N15_2040 $1.   
   @  1902  N15_2050 $1.   
   @  1903  N15_2060 $1.   
   @  1904  N15_2070 $1.   
   @  1905  N15_2071 $1.   
   @  1906  N15_2072 $1.   
   @  1907  N15_2073 $1.   
   @  1908  N15_2074 $1.   
   @  1909  N15_1960 $4.   
   @  1913  N15_1970 $6.   
   @  1913  N15_1971 $4.   
   @  1917  N15_1972 $1.   
   @  1918  N15_1973 $1.   
   @  1919  N15_1980 $1.   
   @  1920  N15_2081 $10.  
   @  1930  N15_2120 $1.   
   @  1931  N15_2130 $1.   
   @  1932  N15_2140 $2.   
   @  1934  N15_2150 $2.   
   @  1936  N15_2170 $10.  
   @  1946  N15_2180 $1.   
   @  1947  N15_2190 $2.   
   @  1949  N15_2200 $2.   
   @  1951  N15_2085 $8.   
   @  1959  N15_2090 $8.   
   @  1967  N15_2092 $8.   
   @  1975  N15_2100 $8.   
   @  1983  N15_2110 $8.   
   @  1991  N15_2111 $8.   
   @  1999  N15_2112 $8.   
   @  2007  N15_2113 $8.   
   @  2015  N15_2116 $1.   
   @  2016  N15_3750 $1.   
   @  2017  N15_3751 $1.   
   @  2018  N15_3752 $1.   
   @  2019  N15_3753 $1.   
   @  2020  N15_3754 $1.   
   @  2021  N15_3755 $1.   
   @  2022  N15_3756 $1.   
   @  2023  N15_3757 $1.   
   @  2024  N15_3758 $1.   
   @  2025  N15_3759 $1.   
   @  2026  N15_3760 $1.   
   @  2027  N15_3761 $1.   
   @  2028  N15_3762 $1.   
   @  2029  N15_3763 $1.   
   @  2030  N15_3764 $1.   
   @  2031  N15_3765 $1.   
   @  2032  N15_3766 $1.   
   @  2033  N15_3767 $1.   
   @  2034  N15_3768 $1.   
   @  2035  N15_3769 $1.   
/* @  2036  N15_1650 $80.  */
   @  2116  N15_1750 $8.   
   @  2124  N15_1751 $2.   
   @  2126  N15_1760 $1.   
   @  2127  N15_1770 $1.   
   @  2128  N15_1780 $1.   
   @  2129  N15_1790 $1.   
   @  2130  N15_1800 $1.   
   @  2131  N15_1810 $50.  
   @  2181  N15_1820 $2.   
   @  2183  N15_1830 $9.   
   @  2192  N15_1840 $3.   
/* @  2195  N15_2700 $1.   */
   @  2196  N15_1860 $8.   
   @  2204  N15_1861 $2.   
   @  2206  N15_1880 $2.   
   @  2208  N15_1842 $50.  
   @  2258  N15_1844 $2.   
   @  2260  N15_1846 $9.   
   @  2269  N15_1910 $4.   
   @  2273  N15_1920 $1.   
   @  2274  N15_1930 $1.   
   @  2275  N15_1940 $3.   
   @  2278  N15_1791 $2.   
   @  2280  N15_1755 $8.   
   @  2288  N15_1756 $2.   
   @  2290  N15_1850 $2.   
   @  2292  N15_1782 $8.   
   @  2300  N15_1783 $1.   
   @  2301  N15_1784 $4.   
   @  2305  N15_1785 $8.   
   @  2313  N15_1786 $1.   
   @  2314  N15_1787 $4.   
   @  2318  N15_1788 $8.   
/* @  2326  N15_1740 $14.  */
               
/* Confidential record */              
   @  3340  N15_2230 $40.  
   @  3380  N15_2240 $40.  
   @  3420  N15_2250 $40.  
   @  3460  N15_2260 $3.   
   @  3463  N15_2270 $3.   
   @  3466  N15_2280 $40.  
   @  3506  N15_2390 $40.  
   @  3546  N15_2290 $60.  
   @  3606  N15_2300 $11.  
   @  3617  N15_2310 $2.   
   @  3619  N15_2320 $9.   
   @  3628  N15_2330 $60.  
   @  3688  N15_2335 $60.  
   @  3748  N15_2350 $60.  
   @  3808  N15_2355 $60.  
   @  3868  N15_2360 $10.  
   @  3878  N15_2380 $6.   
   @  3884  N15_2394 $60.  
   @  3944  N15_2392 $60.  
   @  4004  N15_2393 $60.  
   @  4064  N15_2352 $10.  
   @  4074  N15_2354 $11.  
/* @  4085  N15_1835 $200. */
   @  4285  N15_2445 $10.  
   @  4295  N15_2440 $10.  
   @  4305  N15_2415 $10.  
   @  4315  N15_2410 $10.  
   @  4325  N15_2425 $10.  
   @  4335  N15_2420 $10.  
/* @  4345  N15_1900 $50.  */
   @  4395  N15_2465 $10.  
   @  4405  N15_2460 $8.   
   @  4413  N15_2475 $10.  
   @  4423  N15_2470 $8.   
   @  4431  N15_2485 $10.  
   @  4441  N15_2480 $8.   
   @  4449  N15_2495 $10.  
   @  4459  N15_2490 $8.   
   @  4467  N15_2505 $10.  
   @  4477  N15_2500 $8.   
   @  4535  N15_7010 $25.  
   @  4560  N15_7090 $20.  
   @  4580  N15_7320 $14.  
   @  4594  N15_7480 $2.   
   @  4596  N15_7190 $25.  
   @  4621  N15_7100 $20.  
   @  4641  N15_7011 $25.  
   @  4666  N15_7091 $20.  
   @  4686  N15_7321 $14.  
   @  4700  N15_7481 $2.   
   @  4702  N15_7191 $25.  
   @  4727  N15_7101 $20.  
   @  4747  N15_7012 $25.  
   @  4772  N15_7092 $20.  
   @  4792  N15_7322 $14.  
   @  4806  N15_7482 $2.   
   @  4808  N15_7192 $25.  
   @  4833  N15_7102 $20.  
   @  4853  N15_7013 $25.  
   @  4878  N15_7093 $20.  
   @  4898  N15_7323 $14.  
   @  4912  N15_7483 $2.   
   @  4914  N15_7193 $25.  
   @  4939  N15_7103 $20.  
   @  4959  N15_7014 $25.  
   @  4984  N15_7094 $20.  
   @  5004  N15_7324 $14.  
   @  5018  N15_7484 $2.   
   @  5020  N15_7194 $25.  
   @  5045  N15_7104 $20.  
/* @  5065  N15_2080 $500. */
               
/* NPCR CER and PCOR fields */               
   @  5065  N15_8000 $8.   
   @  5073  N15_8002 $8.   
   @  5081  N15_8005 $8.   
   @  5089  N15_8008 $8.   
   @  5097  N15_8011 $8.   
   @  5105  N15_8015 $8.   
   @  5113  N15_8018 $8.   
   @  5121  N15_8020 $8.   
   @  5129  N15_8021 $2.   
   @  5133  N15_9751 $6.   
   @  5139  N15_9761 $2.   
   @  5141  N15_9771 $6.   
   @  5147  N15_9781 $2.   
   @  5149  N15_9791 $2.   
   @  5151  N15_9801 $6.   
   @  5157  N15_9811 $2.   
   @  5159  N15_9821 $8.   
   @  5167  N15_9831 $2.   
   @  5169  N15_9841 $8.   
   @  5177  N15_9851 $2.   
   @  5179  N15_9752 $6.   
   @  5185  N15_9762 $2.   
   @  5187  N15_9772 $6.   
   @  5193  N15_9782 $2.   
   @  5195  N15_9792 $2.   
   @  5197  N15_9802 $6.   
   @  5203  N15_9812 $2.   
   @  5205  N15_9822 $8.   
   @  5213  N15_9832 $2.   
   @  5215  N15_9842 $8.   
   @  5223  N15_9852 $2.   
   @  5225  N15_9900 $3.   
   @  5228  N15_9901 $8.   
   @  5236  N15_9902 $2.   
   @  5238  N15_9903 $3.   
   @  5241  N15_9904 $8.   
   @  5249  N15_9905 $2.   
   @  5251  N15_9906 $3.   
   @  5254  N15_9907 $8.   
   @  5262  N15_9908 $2.   
   @  5264  N15_9909 $3.   
   @  5267  N15_9910 $8.   
   @  5275  N15_9911 $2.   
   @  5277  N15_9753 $6.   
   @  5283  N15_9763 $2.   
   @  5285  N15_9773 $6.   
   @  5291  N15_9783 $2.   
   @  5293  N15_9793 $2.   
   @  5295  N15_9803 $6.   
   @  5301  N15_9813 $2.   
   @  5303  N15_9823 $8.   
   @  5311  N15_9833 $2.   
   @  5313  N15_9843 $8.   
   @  5321  N15_9853 $2.   
   @  5323  N15_9754 $6.   
   @  5329  N15_9764 $2.   
   @  5331  N15_9774 $6.   
   @  5337  N15_9784 $2.   
   @  5339  N15_9794 $2.   
   @  5341  N15_9804 $6.   
   @  5347  N15_9814 $2.   
   @  5349  N15_9824 $8.   
   @  5357  N15_9834 $2.   
   @  5359  N15_9844 $8.   
   @  5367  N15_9854 $2.   
   @  5369  N15_9755 $6.   
   @  5375  N15_9765 $2.   
   @  5377  N15_9775 $6.   
   @  5383  N15_9785 $2.   
   @  5385  N15_9795 $2.   
   @  5387  N15_9805 $6.   
   @  5393  N15_9815 $2.   
   @  5395  N15_9825 $8.   
   @  5403  N15_9835 $2.   
   @  5405  N15_9845 $8.   
   @  5413  N15_9855 $2.   
   @  5415  N15_9756 $6.   
   @  5421  N15_9766 $2.   
   @  5423  N15_9776 $6.   
   @  5429  N15_9786 $2.   
   @  5431  N15_9796 $2.   
   @  5433  N15_9806 $6.   
   @  5439  N15_9816 $2.   
   @  5441  N15_9826 $8.   
   @  5449  N15_9836 $2.   
   @  5451  N15_9846 $8.   
   @  5459  N15_9856 $2.   
   @  5461  N15_9859 $1.   
   @  5462  N15_9920 $1.   
   @  5463  N15_9921 $2.   
   @  5465  N15_9922 $2.   
   @  5467  N15_9923 $2.   
   @  5469  N15_9924 $2.   
   @  5471  N15_9925 $2.   
   @  5473  N15_9926 $1.   
   @  5474  N15_9927 $2.   
   @  5476  N15_9931 $6.   
   @  5482  N15_9932 $6.   
   @  5488  N15_9933 $6.   
   @  5494  N15_9934 $6.   
   @  5500  N15_9935 $6.   
   @  5506  N15_9936 $6.   
   @  5512  N15_9941 $6.   
   @  5518  N15_9942 $6.   
   @  5524  N15_9951 $6.   
   @  5530  N15_9952 $6.   
   @  5536  N15_9955 $2.   
   @  5538  N15_9861 $6.   
   @  5544  N15_9862 $6.   
   @  5550  N15_9871 $6.   
   @  5556  N15_9872 $6.   
   @  5562  N15_9880 $1.   
   @  5563  N15_9881 $1.   
   @  5564  N15_9882 $1.   
               
/* Text record */ 
   @  5565  N15_2520 $1000.   
   @  6565  N15_2530 $1000.   
   @  7565  N15_2540 $1000.   
   @  8565  N15_2550 $1000.   
   @  9565  N15_2560 $1000.   
   @  10565 N15_2570 $1000.   
   @  11565 N15_2580 $100. 
   @  11665 N15_2590 $100. 
   @  11765 N15_2600 $1000.   
   @  12765 N15_2610 $1000.   
   @  13765 N15_2620 $1000.   
   @  14765 N15_2630 $1000.   
   @  15765 N15_2640 $1000.   
   @  16765 N15_2650 $1000.   
   @  17765 N15_2660 $1000.   
   @  18765 N15_2670 $1000.   
   @  19765 N15_2680 $1000.   
   @  20765 N15_2690 60.   
/* @  20825 N15_2210 2000. */
               
;
run;
