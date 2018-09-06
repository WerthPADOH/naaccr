/* SAS PROGRAM TO READ AND WRITE NAACCR V16 RECORD LAYOUTS */

*** CHANGE FILE REFERENCES FOR INPUT AND OUTPUT FLAT ASCII FILES ***;

filename inv16     'V:\data\CANCER\NAACCR\DataStandardsAndDictionary\V16\Test2.txd';
filename outv16    'V:\data\CANCER\NAACCR\DataStandardsAndDictionary\V16\Test3.txd';


data SAStest;  
* infile inv16 lrecl =  3339 pad missover; /* INCIDENCE */
* infile inv16 lrecl =  5564 pad missover; /* CONFIDENTIAL */
  infile inv16 lrecl = 22824 pad missover; /* TEXT */

/* INCIDENCE VARIABLES */
input @1    N16_10   $char1.  @; label N16_10   ='10_Record Type';   
input @2    N16_30   $char1.  @; label N16_30   ='30_Registry Type'; 
*input   @3    N16_37   $char14. @; *label   N16_37   ='37_Reserved 00';   
input @17   N16_50   $char3.  @; label N16_50   ='50_NAACCR Record Version';  
input @20   N16_45   $char10. @; label N16_45   ='45_NPI--Registry ID'; 
input @30   N16_40   $char10. @; label N16_40   ='40_Registry ID';   
input @40   N16_60   $char2.  @; label N16_60   ='60_Tumor Record Number'; 
input @42   N16_20   $char8.  @; label N16_20   ='20_Patient ID Number';   
input @50   N16_21   $char8.  @; label N16_21   ='21_Patient System ID-Hosp'; 
*input   @58   N16_370  $char37. @; *label   N16_370  ='370_Reserved 01';  
input @95   N16_70   $char50. @; label N16_70   ='70_Addr at DX--City'; 
input @145  N16_80   $char2.  @; label N16_80   ='80_Addr at DX--State';   
input @147  N16_100  $char9.  @; label N16_100  ='100_Addr at DX--Postal Code';  
input @156  N16_90   $char3.  @; label N16_90   ='90_County at DX';  
input @159  N16_110  $char6.  @; label N16_110  ='110_Census Tract 1970/80/90';  
input @165  N16_368  $char1.  @; label N16_368  ='368_Census Block Grp 1970-90'; 
input @166  N16_120  $char1.  @; label N16_120  ='120_Census Cod Sys 1970/80/90';   
input @167  N16_364  $char1.  @; label N16_364  ='364_Census Tr Cert 1970/80/90';   
input @168  N16_130  $char6.  @; label N16_130  ='130_Census Tract 2000';  
input @174  N16_362  $char1.  @; label N16_362  ='362_Census Block Group 2000';  
input @175  N16_365  $char1.  @; label N16_365  ='365_Census Tr Certainty 2000'; 
input @176  N16_150  $char1.  @; label N16_150  ='150_Marital Status at DX';  
input @177  N16_160  $char2.  @; label N16_160  ='160_Race 1'; 
input @179  N16_161  $char2.  @; label N16_161  ='161_Race 2'; 
input @181  N16_162  $char2.  @; label N16_162  ='162_Race 3'; 
input @183  N16_163  $char2.  @; label N16_163  ='163_Race 4'; 
input @185  N16_164  $char2.  @; label N16_164  ='164_Race 5'; 
input @187  N16_170  $char1.  @; label N16_170  ='170_Race Coding Sys--Current'; 
input @188  N16_180  $char1.  @; label N16_180  ='180_Race Coding Sys--Original';   
input @189  N16_190  $char1.  @; label N16_190  ='190_Spanish/Hispanic Origin';  
input @190  N16_200  $char1.  @; label N16_200  ='200_Computed Ethnicity'; 
input @191  N16_210  $char1.  @; label N16_210  ='210_Computed Ethnicity Source';   
input @192  N16_220  $char1.  @; label N16_220  ='220_Sex'; 
input @193  N16_230  $char3.  @; label N16_230  ='230_Age at Diagnosis';   
input @196  N16_240  $char8.  @; label N16_240  ='240_Date of Birth';   
input @204  N16_241  $char2.  @; label N16_241  ='241_Date of Birth Flag'; 
input @206  N16_250  $char3.  @; label N16_250  ='250_Birthplace';   
input @209  N16_270  $char3.  @; label N16_270  ='270_Census Occ Code 1970-2000';   
input @212  N16_280  $char3.  @; label N16_280  ='280_Census Ind Code 1970-2000';   
input @215  N16_290  $char1.  @; label N16_290  ='290_Occupation Source';  
input @216  N16_300  $char1.  @; label N16_300  ='300_Industry Source'; 
input @217  N16_310  $char100.   @; label N16_310  ='310_Text--Usual Occupation';   
input @317  N16_320  $char100.   @; label N16_320  ='320_Text--Usual Industry';  
input @417  N16_330  $char1.  @; label N16_330  ='330_Census Occ/Ind Sys 70-00'; 
input @418  N16_191  $char1.  @; label N16_191  ='191_NHIA Derived Hisp Origin'; 
input @419  N16_193  $char2.  @; label N16_193  ='193_Race--NAPIIA(derived API)';   
input @421  N16_192  $char1.  @; label N16_192  ='192_IHS Link';  
input @422  N16_366  $char2.  @; label N16_366  ='366_GIS Coordinate Quality';   
input @424  N16_3300 $char2.  @; label N16_3300 ='3300_RuralUrban Continuum 1993';  
input @426  N16_3310 $char2.  @; label N16_3310 ='3310_RuralUrban Continuum 2003';  
input @428  N16_135  $char6.  @; label N16_135  ='135_Census Tract 2010';  
input @434  N16_363  $char1.  @; label N16_363  ='363_Census Block Group 2010';  
input @435  N16_367  $char1.  @; label N16_367  ='367_Census Tr Certainty 2010'; 
input @436  N16_102  $char3.  @; label N16_102  ='102_Addr at DX--Country';   
input @439  N16_1832 $char3.  @; label N16_1832 ='1832_Addr Current--Country';   
input @442  N16_252  $char2.  @; label N16_252  ='252_Birthplace--State';  
input @444  N16_254  $char3.  @; label N16_254  ='254_Birthplace--Country';   
input @447  N16_1847 $char3.  @; label N16_1847 ='1847_FollowUp Contact--Country';  
input @450  N16_1942 $char2.  @; label N16_1942 ='1942_Place of Death--State';   
input @452  N16_1944 $char3.  @; label N16_1944 ='1944_Place of Death--Country'; 
input @455  N16_272  $char4.  @; label N16_272  ='272_Census Ind Code 2010 CDC';  /*Revised*/  
input @459  N16_282  $char4.  @; label N16_282  ='282_Census Occ Code 2010 CDC';  /*Revised*/  
input @463  N16_145  $char1.  @; label N16_145  ='145_Census Tr Poverty Indictr'; 
input @464  N16_94   $char3.  @; label N16_94   ='94_County at DX Geocode1990';  /*New*/
input @467  N16_95   $char3.  @; label N16_95   ='95_County at DX Geocode2000';  /*New*/
input @470  N16_96   $char3.  @; label N16_96   ='96_County at DX Geocode2010';  /*New*/
input @473  N16_97   $char3.  @; label N16_97   ='97_County at DX Geocode2020';  /*New*/
input @476  N16_3312 $char2.  @; label N16_3312 ='3312_RuralUrban Continuum 2013';  /*New*/
*input   @478  N16_530  $char50. @; *label   N16_530  ='530_Reserved 02';  /*Revised*/ 
input @528  N16_380  $char2.  @; label N16_380  ='380_Sequence Number--Central'; 
input @530  N16_390  $char8.  @; label N16_390  ='390_Date of Diagnosis';  
input @538  N16_391  $char2.  @; label N16_391  ='391_Date of Diagnosis Flag';   
input @540  N16_400  $char4.  @; label N16_400  ='400_Primary Site'; 
input @544  N16_410  $char1.  @; label N16_410  ='410_Laterality';   
input @545  N16_419  $char5.  @; label N16_419  ='419_Morph--Type&Behav ICD-O-2';   
input @545  N16_420  $char4.  @; label N16_420  ='420_Histology (92-00) ICD-O-2';   
input @549  N16_430  $char1.  @; label N16_430  ='430_Behavior (92-00) ICD-O-2'; 
input @550  N16_521  $char5.  @; label N16_521  ='521_Morph--Type&Behav ICD-O-3';   
input @550  N16_522  $char4.  @; label N16_522  ='522_Histologic Type ICD-O-3';  
input @554  N16_523  $char1.  @; label N16_523  ='523_Behavior Code ICD-O-3'; 
input @555  N16_440  $char1.  @; label N16_440  ='440_Grade';  
input @556  N16_441  $char1.  @; label N16_441  ='441_Grade Path Value';   
input @557  N16_449  $char1.  @; label N16_449  ='449_Grade Path System';  
input @558  N16_450  $char1.  @; label N16_450  ='450_Site Coding Sys--Current'; 
input @559  N16_460  $char1.  @; label N16_460  ='460_Site Coding Sys--Original';   
input @560  N16_470  $char1.  @; label N16_470  ='470_Morph Coding Sys--Current';   
input @561  N16_480  $char1.  @; label N16_480  ='480_Morph Coding Sys--Originl';   
input @562  N16_490  $char1.  @; label N16_490  ='490_Diagnostic Confirmation';  
input @563  N16_500  $char1.  @; label N16_500  ='500_Type of Reporting Source'; 
input @564  N16_501  $char2.  @; label N16_501  ='501_Casefinding Source'; 
input @566  N16_442  $char1.  @; label N16_442  ='442_Ambiguous Terminology DX'; 
input @567  N16_443  $char8.  @; label N16_443  ='443_Date Conclusive DX'; 
input @575  N16_448  $char2.  @; label N16_448  ='448_Date Conclusive DX Flag';  
input @577  N16_444  $char2.  @; label N16_444  ='444_Mult Tum Rpt as One Prim'; 
input @579  N16_445  $char8.  @; label N16_445  ='445_Date of Mult Tumors';   
input @587  N16_439  $char2.  @; label N16_439  ='439_Date of Mult Tumors Flag'; 
input @589  N16_446  $char2.  @; label N16_446  ='446_Multiplicity Counter'; 
*input   @591  N16_680  $char100.   @; *label   N16_680  ='680_Reserved 03';  
input @691  N16_545  $char10. @; label N16_545  ='545_NPI--Reporting Facility';  
input @701  N16_540  $char10. @; label N16_540  ='540_Reporting Facility'; 
input @711  N16_3105 $char10. @; label N16_3105 ='3105_NPI--Archive FIN';  
input @721  N16_3100 $char10. @; label N16_3100 ='3100_Archive FIN'; 
input @731  N16_550  $char9.  @; label N16_550  ='550_Accession Number--Hosp';   
input @740  N16_560  $char2.  @; label N16_560  ='560_Sequence Number--Hospital';   
input @742  N16_570  $char3.  @; label N16_570  ='570_Abstracted By';   
input @745  N16_580  $char8.  @; label N16_580  ='580_Date of 1st Contact';   
input @753  N16_581  $char2.  @; label N16_581  ='581_Date of 1st Contact Flag'; 
input @755  N16_590  $char8.  @; label N16_590  ='590_Date of Inpt Adm';   
input @763  N16_591  $char2.  @; label N16_591  ='591_Date of Inpt Adm Flag'; 
input @765  N16_600  $char8.  @; label N16_600  ='600_Date of Inpt Disch'; 
input @773  N16_601  $char2.  @; label N16_601  ='601_Date of Inpt Disch Flag';  
input @775  N16_605  $char1.  @; label N16_605  ='605_Inpatient Status';   
input @776  N16_610  $char2.  @; label N16_610  ='610_Class of Case';   
input @778  N16_630  $char2.  @; label N16_630  ='630_Primary Payer at DX';   
*input   @780  N16_2400 $char1.  @; *label   N16_2400 ='2400_Reserved 15'; 
input @781  N16_668  $char1.  @; label N16_668  ='668_RX Hosp--Surg App 2010';   
input @782  N16_670  $char2.  @; label N16_670  ='670_RX Hosp--Surg Prim Site';  
input @784  N16_672  $char1.  @; label N16_672  ='672_RX Hosp--Scope Reg LN Sur';   
input @785  N16_674  $char1.  @; label N16_674  ='674_RX Hosp--Surg Oth Reg/Dis';   
input @786  N16_676  $char2.  @; label N16_676  ='676_RX Hosp--Reg LN Removed';  
*input   @788  N16_2450 $char1.  @; *label   N16_2450 ='2450_Reserved 16'; 
input @789  N16_690  $char1.  @; label N16_690  ='690_RX Hosp--Radiation'; 
input @790  N16_700  $char2.  @; label N16_700  ='700_RX Hosp--Chemo';  
input @792  N16_710  $char2.  @; label N16_710  ='710_RX Hosp--Hormone';   
input @794  N16_720  $char2.  @; label N16_720  ='720_RX Hosp--BRM'; 
input @796  N16_730  $char1.  @; label N16_730  ='730_RX Hosp--Other';  
input @797  N16_740  $char2.  @; label N16_740  ='740_RX Hosp--DX/Stg Proc';  
input @799  N16_3280 $char1.  @; label N16_3280 ='3280_RX Hosp--Palliative Proc';   
input @800  N16_746  $char2.  @; label N16_746  ='746_RX Hosp--Surg Site 98-02'; 
input @802  N16_747  $char1.  @; label N16_747  ='747_RX Hosp--Scope Reg 98-02'; 
input @803  N16_748  $char1.  @; label N16_748  ='748_RX Hosp--Surg Oth 98-02';  
*input   @804  N16_750  $char30.   @; *label   N16_750  ='750_Reserved 04';  /*Revised*/
input @834  N16_930  $char2.  @; label N16_930  ='930_TNM Path Staged By';  /*Revised*/
input @836  N16_990  $char2.  @; label N16_990  ='990_TNM Clin Staged By';  /*Revised*/
input @838  N16_1112 $char1.  @; label N16_1112 ='1112_Mets at DX-Bone';  /*New*/
input @839  N16_1113 $char1.  @; label N16_1113 ='1113_Mets at DX-Brain';  /*New*/
input @840  N16_1114 $char1.  @; label N16_1114 ='1114_Mets at Dx-Distant LN';  /*New*/
input @841  N16_1115 $char1.  @; label N16_1115 ='1115_Mets at DX-Liver';  /*New*/
input @842  N16_1116 $char1.  @; label N16_1116 ='1116_Mets at DX-Lung';  /*New*/
input @843  N16_1117 $char1.  @; label N16_1117 ='1117_Mets at DX-Other';  /*New*/
input @844  N16_752  $char3.  @; label N16_752  ='752_Tumor Size Clinical';  /*New*/
input @847  N16_754  $char3.  @; label N16_754  ='754_Tumor Size Pathologic';  /*New*/
input @850  N16_756  $char3.  @; label N16_756  ='756_Tumor Size Summary';  /*New*/
input @853  N16_3605 $char5.  @; label N16_3605 ='3605_Derived SEER Path Stg Grp';  /*New*/
input @858  N16_3610 $char5.  @; label N16_3610 ='3610_Derived SEER Clin Stg Grp';  /*New*/
input @863  N16_3614 $char5.  @; label N16_3614 ='3614_Derived SEER Cmb Stg Grp';  /*New*/
input @868  N16_3616 $char5.  @; label N16_3616 ='3616_Derived SEER Combined T';  /*New*/
input @873  N16_3618 $char5.  @; label N16_3618 ='3618_Derived SEER Combined N';  /*New*/
input @878  N16_3620 $char5.  @; label N16_3620 ='3620_Derived SEER Combined M';  /*New*/
input @883  N16_3622 $char1.  @; label N16_3622 ='3622_Derived SEER Cmb T Src';  /*New*/
input @884  N16_3624 $char1.  @; label N16_3624 ='3624_Derived SEER Cmb N Src';  /*New*/
input @885  N16_3626 $char1.  @; label N16_3626 ='3626_Derived SEER Cmb M Src';  /*New*/
input @886  N16_772  $char3.  @; label N16_772  ='772_SEER Primary Tumor';  /*New*/
input @889  N16_774  $char3.  @; label N16_774  ='774_SEER Regional Nodes';  /*New*/
input @892  N16_776  $char2.  @; label N16_776  ='776_SEER Mets';  /*New*/
input @894  N16_762  $char1.  @; label N16_762  ='762_Derived SS2017';  /*New*/
input @895  N16_764  $char1.  @; label N16_764  ='764_Directly Assigned SS2017';  /*New*/
input @896  N16_3650 $char4.  @; label N16_3650 ='3650_NPCR Derived Clin Stg Grp';  /*New*/
input @900  N16_3655 $char4.  @; label N16_3655 ='3655_NPCR Derived Path Stg Grp';  /*New*/
input @904  N16_759  $char1.  @; label N16_759  ='759_SEER Summary Stage 2000';  
input @905  N16_760  $char1.  @; label N16_760  ='760_SEER Summary Stage 1977';  
input @906  N16_779  $char12. @; label N16_779  ='779_Extent of Disease 10-Dig'; 
input @906  N16_780  $char3.  @; label N16_780  ='780_EOD--Tumor Size'; 
input @909  N16_790  $char2.  @; label N16_790  ='790_EOD--Extension';  
input @911  N16_800  $char2.  @; label N16_800  ='800_EOD--Extension Prost Path';   
input @913  N16_810  $char1.  @; label N16_810  ='810_EOD--Lymph Node Involv';   
input @914  N16_820  $char2.  @; label N16_820  ='820_Regional Nodes Positive';  
input @916  N16_830  $char2.  @; label N16_830  ='830_Regional Nodes Examined';  
input @918  N16_840  $char13. @; label N16_840  ='840_EOD--Old 13 Digit';  
input @931  N16_850  $char2.  @; label N16_850  ='850_EOD--Old 2 Digit';   
input @933  N16_860  $char4.  @; label N16_860  ='860_EOD--Old 4 Digit';   
input @937  N16_870  $char1.  @; label N16_870  ='870_Coding System for EOD'; 
input @938  N16_1060 $char2.  @; label N16_1060 ='1060_TNM Edition Number';   
input @940  N16_880  $char4.  @; label N16_880  ='880_TNM Path T';   
input @944  N16_890  $char4.  @; label N16_890  ='890_TNM Path N';   
input @948  N16_900  $char4.  @; label N16_900  ='900_TNM Path M';   
input @952  N16_910  $char4.  @; label N16_910  ='910_TNM Path Stage Group';  
input @956  N16_920  $char1.  @; label N16_920  ='920_TNM Path Descriptor';   
*input @957  N16_2162 $char1.  @; *label N16_2162  ='2162_Reserved 19';  /*New*/
input @958  N16_940  $char4.  @; label N16_940  ='940_TNM Clin T';   
input @962  N16_950  $char4.  @; label N16_950  ='950_TNM Clin N';   
input @966  N16_960  $char4.  @; label N16_960  ='960_TNM Clin M';   
input @970  N16_970  $char4.  @; label N16_970  ='970_TNM Clin Stage Group';  
input @974  N16_980  $char1.  @; label N16_980  ='980_TNM Clin Descriptor';
*input @975  N16_2163  $char1.  @; *label N16_2163  ='2163_Reserved 20';  /*New*/
input @976  N16_1120 $char2.  @; label N16_1120 ='1120_Pediatric Stage';   
input @978  N16_1130 $char2.  @; label N16_1130 ='1130_Pediatric Staging System';   
input @980  N16_1140 $char1.  @; label N16_1140 ='1140_Pediatric Staged By';  
input @981  N16_1150 $char1.  @; label N16_1150 ='1150_Tumor Marker 1'; 
input @982  N16_1160 $char1.  @; label N16_1160 ='1160_Tumor Marker 2'; 
input @983  N16_1170 $char1.  @; label N16_1170 ='1170_Tumor Marker 3'; 
input @984  N16_1182 $char1.  @; label N16_1182 ='1182_Lymph-vascular Invasion'; 
input @985  N16_2800 $char3.  @; label N16_2800 ='2800_CS Tumor Size';  
input @988  N16_2810 $char3.  @; label N16_2810 ='2810_CS Extension';   
input @991  N16_2820 $char1.  @; label N16_2820 ='2820_CS Tumor Size/Ext Eval';  
input @992  N16_2830 $char3.  @; label N16_2830 ='2830_CS Lymph Nodes'; 
input @995  N16_2840 $char1.  @; label N16_2840 ='2840_CS Lymph Nodes Eval';  
input @996  N16_2850 $char2.  @; label N16_2850 ='2850_CS Mets at DX';  
input @998  N16_2860 $char1.  @; label N16_2860 ='2860_CS Mets Eval';   
input @999  N16_2851 $char1.  @; label N16_2851 ='2851_CS Mets at Dx-Bone';   
input @1000 N16_2852 $char1.  @; label N16_2852 ='2852_CS Mets at Dx-Brain';  
input @1001 N16_2853 $char1.  @; label N16_2853 ='2853_CS Mets at Dx-Liver';  
input @1002 N16_2854 $char1.  @; label N16_2854 ='2854_CS Mets at Dx-Lung';   
input @1003 N16_2880 $char3.  @; label N16_2880 ='2880_CS Site-Specific Factor 1';  
input @1006 N16_2890 $char3.  @; label N16_2890 ='2890_CS Site-Specific Factor 2';  
input @1009 N16_2900 $char3.  @; label N16_2900 ='2900_CS Site-Specific Factor 3';  
input @1012 N16_2910 $char3.  @; label N16_2910 ='2910_CS Site-Specific Factor 4';  
input @1015 N16_2920 $char3.  @; label N16_2920 ='2920_CS Site-Specific Factor 5';  
input @1018 N16_2930 $char3.  @; label N16_2930 ='2930_CS Site-Specific Factor 6';  
input @1021 N16_2861 $char3.  @; label N16_2861 ='2861_CS Site-Specific Factor 7';  
input @1024 N16_2862 $char3.  @; label N16_2862 ='2862_CS Site-Specific Factor 8';  
input @1027 N16_2863 $char3.  @; label N16_2863 ='2863_CS Site-Specific Factor 9';  
input @1030 N16_2864 $char3.  @; label N16_2864 ='2864_CS Site-Specific Factor10';  
input @1033 N16_2865 $char3.  @; label N16_2865 ='2865_CS Site-Specific Factor11';  
input @1036 N16_2866 $char3.  @; label N16_2866 ='2866_CS Site-Specific Factor12';  
input @1039 N16_2867 $char3.  @; label N16_2867 ='2867_CS Site-Specific Factor13';  
input @1042 N16_2868 $char3.  @; label N16_2868 ='2868_CS Site-Specific Factor14';  
input @1045 N16_2869 $char3.  @; label N16_2869 ='2869_CS Site-Specific Factor15';  
input @1048 N16_2870 $char3.  @; label N16_2870 ='2870_CS Site-Specific Factor16';  
input @1051 N16_2871 $char3.  @; label N16_2871 ='2871_CS Site-Specific Factor17';  
input @1054 N16_2872 $char3.  @; label N16_2872 ='2872_CS Site-Specific Factor18';  
input @1057 N16_2873 $char3.  @; label N16_2873 ='2873_CS Site-Specific Factor19';  
input @1060 N16_2874 $char3.  @; label N16_2874 ='2874_CS Site-Specific Factor20';  
input @1063 N16_2875 $char3.  @; label N16_2875 ='2875_CS Site-Specific Factor21';  
input @1066 N16_2876 $char3.  @; label N16_2876 ='2876_CS Site-Specific Factor22';  
input @1069 N16_2877 $char3.  @; label N16_2877 ='2877_CS Site-Specific Factor23';  
input @1072 N16_2878 $char3.  @; label N16_2878 ='2878_CS Site-Specific Factor24';  
input @1075 N16_2879 $char3.  @; label N16_2879 ='2879_CS Site-Specific Factor25';  
input @1078 N16_2730 $char3.  @; label N16_2730 ='2730_CS PreRx Tumor Size';  
input @1081 N16_2735 $char3.  @; label N16_2735 ='2735_CS PreRx Extension';   
input @1084 N16_2740 $char1.  @; label N16_2740 ='2740_CS PreRx Tum Sz/Ext Eval';   
input @1085 N16_2750 $char3.  @; label N16_2750 ='2750_CS PreRx Lymph Nodes'; 
input @1088 N16_2755 $char1.  @; label N16_2755 ='2755_CS PreRx Reg Nodes Eval'; 
input @1089 N16_2760 $char2.  @; label N16_2760 ='2760_CS PreRx Mets at DX';  
input @1091 N16_2765 $char1.  @; label N16_2765 ='2765_CS PreRx Mets Eval';   
input @1092 N16_2770 $char3.  @; label N16_2770 ='2770_CS PostRx Tumor Size'; 
input @1095 N16_2775 $char3.  @; label N16_2775 ='2775_CS PostRx Extension';  
input @1098 N16_2780 $char3.  @; label N16_2780 ='2780_CS PostRx Lymph Nodes';   
input @1101 N16_2785 $char2.  @; label N16_2785 ='2785_CS PostRx Mets at DX'; 
input @1103 N16_2940 $char2.  @; label N16_2940 ='2940_Derived AJCC-6 T';  
input @1105 N16_2950 $char1.  @; label N16_2950 ='2950_Derived AJCC-6 T Descript';  
input @1106 N16_2960 $char2.  @; label N16_2960 ='2960_Derived AJCC-6 N';  
input @1108 N16_2970 $char1.  @; label N16_2970 ='2970_Derived AJCC-6 N Descript';  
input @1109 N16_2980 $char2.  @; label N16_2980 ='2980_Derived AJCC-6 M';  
input @1111 N16_2990 $char1.  @; label N16_2990 ='2990_Derived AJCC-6 M Descript';  
input @1112 N16_3000 $char2.  @; label N16_3000 ='3000_Derived AJCC-6 Stage Grp';   
input @1114 N16_3400 $char3.  @; label N16_3400 ='3400_Derived AJCC-7 T';  
input @1117 N16_3402 $char1.  @; label N16_3402 ='3402_Derived AJCC-7 T Descript';  
input @1118 N16_3410 $char3.  @; label N16_3410 ='3410_Derived AJCC-7 N';  
input @1121 N16_3412 $char1.  @; label N16_3412 ='3412_Derived AJCC-7 N Descript';  
input @1122 N16_3420 $char3.  @; label N16_3420 ='3420_Derived AJCC-7 M';  
input @1125 N16_3422 $char1.  @; label N16_3422 ='3422_Derived AJCC-7 M Descript';  
input @1126 N16_3430 $char3.  @; label N16_3430 ='3430_Derived AJCC-7 Stage Grp';   
input @1129 N16_3440 $char3.  @; label N16_3440 ='3440_Derived PreRx-7 T'; 
input @1132 N16_3442 $char1.  @; label N16_3442 ='3442_Derived PreRx-7 T Descrip';  
input @1133 N16_3450 $char3.  @; label N16_3450 ='3450_Derived PreRx-7 N'; 
input @1136 N16_3452 $char1.  @; label N16_3452 ='3452_Derived PreRx-7 N Descrip';  
input @1137 N16_3460 $char3.  @; label N16_3460 ='3460_Derived PreRx-7 M'; 
input @1140 N16_3462 $char1.  @; label N16_3462 ='3462_Derived PreRx-7 M Descrip';  
input @1141 N16_3470 $char3.  @; label N16_3470 ='3470_Derived PreRx-7 Stage Grp';  
input @1144 N16_3480 $char3.  @; label N16_3480 ='3480_Derived PostRx-7 T';   
input @1147 N16_3482 $char3.  @; label N16_3482 ='3482_Derived PostRx-7 N';   
input @1150 N16_3490 $char2.  @; label N16_3490 ='3490_Derived PostRx-7 M';   
input @1152 N16_3492 $char3.  @; label N16_3492 ='3492_Derived PostRx-7 Stge Grp';  
input @1155 N16_3010 $char1.  @; label N16_3010 ='3010_Derived SS1977'; 
input @1156 N16_3020 $char1.  @; label N16_3020 ='3020_Derived SS2000'; 
input @1157 N16_3600 $char1.  @; label N16_3600 ='3600_Derived Neoadjuv Rx Flag';   
input @1158 N16_3030 $char1.  @; label N16_3030 ='3030_Derived AJCC--Flag';   
input @1159 N16_3040 $char1.  @; label N16_3040 ='3040_Derived SS1977--Flag'; 
input @1160 N16_3050 $char1.  @; label N16_3050 ='3050_Derived SS2000--Flag'; 
input @1161 N16_2937 $char6.  @; label N16_2937 ='2937_CS Version Input Current';   
input @1167 N16_2935 $char6.  @; label N16_2935 ='2935_CS Version Input Original';  
input @1173 N16_2936 $char6.  @; label N16_2936 ='2936_CS Version Derived';   
input @1179 N16_3700 $char1.  @; label N16_3700 ='3700_SEER Site-Specific Fact 1';  
input @1180 N16_3702 $char1.  @; label N16_3702 ='3702_SEER Site-Specific Fact 2';  
input @1181 N16_3704 $char1.  @; label N16_3704 ='3704_SEER Site-Specific Fact 3';  
input @1182 N16_3706 $char1.  @; label N16_3706 ='3706_SEER Site-Specific Fact 4';  
input @1183 N16_3708 $char1.  @; label N16_3708 ='3708_SEER Site-Specific Fact 5';  
input @1184 N16_3710 $char1.  @; label N16_3710 ='3710_SEER Site-Specific Fact 6';  
input @1185 N16_3165 $char1.  @; label N16_3165 ='3165_ICD Revision Comorbid';   
input @1186 N16_3110 $char5.  @; label N16_3110 ='3110_Comorbid/Complication 1'; 
input @1191 N16_3120 $char5.  @; label N16_3120 ='3120_Comorbid/Complication 2'; 
input @1196 N16_3130 $char5.  @; label N16_3130 ='3130_Comorbid/Complication 3'; 
input @1201 N16_3140 $char5.  @; label N16_3140 ='3140_Comorbid/Complication 4'; 
input @1206 N16_3150 $char5.  @; label N16_3150 ='3150_Comorbid/Complication 5'; 
input @1211 N16_3160 $char5.  @; label N16_3160 ='3160_Comorbid/Complication 6'; 
input @1216 N16_3161 $char5.  @; label N16_3161 ='3161_Comorbid/Complication 7'; 
input @1221 N16_3162 $char5.  @; label N16_3162 ='3162_Comorbid/Complication 8'; 
input @1226 N16_3163 $char5.  @; label N16_3163 ='3163_Comorbid/Complication 9'; 
input @1231 N16_3164 $char5.  @; label N16_3164 ='3164_Comorbid/Complication 10';   
input @1236 N16_3780 $char7.  @; label N16_3780 ='3780_Secondary Diagnosis 1';   
input @1243 N16_3782 $char7.  @; label N16_3782 ='3782_Secondary Diagnosis 2';   
input @1250 N16_3784 $char7.  @; label N16_3784 ='3784_Secondary Diagnosis 3';   
input @1257 N16_3786 $char7.  @; label N16_3786 ='3786_Secondary Diagnosis 4';   
input @1264 N16_3788 $char7.  @; label N16_3788 ='3788_Secondary Diagnosis 5';   
input @1271 N16_3790 $char7.  @; label N16_3790 ='3790_Secondary Diagnosis 6';   
input @1278 N16_3792 $char7.  @; label N16_3792 ='3792_Secondary Diagnosis 7';   
input @1285 N16_3794 $char7.  @; label N16_3794 ='3794_Secondary Diagnosis 8';   
input @1292 N16_3796 $char7.  @; label N16_3796 ='3796_Secondary Diagnosis 9';   
input @1299 N16_3798 $char7.  @; label N16_3798 ='3798_Secondary Diagnosis 10';  
         
   
/* NPCR-SPECIFIC FIELDS FOR NBCCEDP LINKAGE */                          
input @1306 N16_9980 $char1.  @; label N16_9980 ='9980_EDP MDE Link';   
input @1307 N16_9981 $char8.  @; label N16_9981 ='9981_EDP MDE Link Date'; 


/* NPCR-SPECIFIC FIELDS FOR FOREVER 7 CER VARIABLES AND Over-ride CER - ONLY FOR CER STATES */
input @1315 N16_9960 $char2.  @; label N16_9960 ='9960_Height';   
input @1317 N16_9961 $char3.  @; label N16_9961 ='9961_Weight';   
input @1320 N16_9965 $char1.  @; label N16_9965 ='9965_Tobacco Use Cigarettes';  
input @1321 N16_9966 $char1.  @; label N16_9966 ='9966_Tobacco Use Other Smoke'; 
input @1322 N16_9967 $char1.  @; label N16_9967 ='9967_Tobacco Use Smokeless';   
input @1323 N16_9968 $char1.  @; label N16_9968 ='9968_Tobacco Use NOS';   
input @1324 N16_9970 $char1.  @; label N16_9970 ='9970_Source Comorbidity';
input @1325 N16_9969 $char1.  @; label N16_9969 ='9969_Over-ride CER';  
*input   @1306 N16_3720 $char75. @; *label   N16_3720 ='3720_NPCR Specific Field 1';
*input   @1381 N16_1180 $char55. @; *label   N16_1180 ='1180_Reserved 05'; 


/* NPCR-SPECIFIC FIELDS FOR PCOR VARIABLES - ONLY FOR PCOR STATES */ 
input @1326 N16_8003 $char1.  @; label N16_8003 ='8003_Comp1stCrsStatusDatSrc';  
input @1327 N16_8004 $char1.  @; label N16_8004 ='8004_DsFreeStatus';   
input @1328 N16_8006 $char1.  @; label N16_8006 ='8006_FrstDsFreeDatSrcUsd';  
input @1329 N16_8007 $char1.  @; label N16_8007 ='8007_AddnlDsFreeStatus'; 
input @1330 N16_8009 $char1.  @; label N16_8009 ='8009_AddnlDsFreeDatSrcUsd'; 
input @1331 N16_8010 $char1.  @; label N16_8010 ='8010_RecStatus';   
input @1332 N16_8012 $char2.  @; label N16_8012 ='8012_TypeOfRecurrence';  
input @1334 N16_8013 $char1.  @; label N16_8013 ='8013_RcrDatSrc';   
input @1335 N16_8014 $char1.  @; label N16_8014 ='8014_ProgResidDsStatus'; 
input @1336 N16_8016 $char1.  @; label N16_8016 ='8016_ProgResidDatSrcUsd';   
input @1337 N16_8017 $char1.  @; label N16_8017 ='8017_SubseqPrmryStatus'; 
input @1338 N16_8019 $char1.  @; label N16_8019 ='8019_SubseqPrmryDatSrcUsd'; 
input @1339 N16_8022 $char2.  @; label N16_8022 ='8022_PCOR_SubseqRx2ndCrsSurg'; 
input @1341 N16_8023 $char2.  @; label N16_8023 ='8023_PCOR_SubseqRx2ndCrsRad';  
input @1343 N16_8024 $char2.  @; label N16_8024 ='8024_PCOR_SubseqRx2ndCrsChemo';   
input @1345 N16_8025 $char2.  @; label N16_8025 ='8025_PCOR_SubseqRx2ndCrsBRM';  
input @1347 N16_8026 $char1.  @; label N16_8026 ='8026_PCOR_SubseqRx2ndCrsOther';   
input @1348 N16_8001 $char1.  @; label N16_8001 ='8001_Comp1stCrsRxStat';  


/* NPCR-SPECIFIC FIELDS FOR c AND p MODIFIERS */
input @1349 N16_12000 $char2.  @; label N16_12000 ='12000_cT Blank Validation Flag';  /*New*/
input @1351 N16_12001 $char2.  @; label N16_12001 ='12001_cN Blank Validation Flag';  /*New*/
input @1353 N16_12002 $char2.  @; label N16_12002 ='12002_cM Blank Validation Flag';  /*New*/
input @1355 N16_12003 $char2.  @; label N16_12003 ='12003_pT Blank Validation Flag';  /*New*/
input @1357 N16_12004 $char2.  @; label N16_12004 ='12004_pN Blank Validation Flag';  /*New*/
input @1359 N16_12005 $char2.  @; label N16_12005 ='12005_pM Blank Validation Flag';  /*New*/
  
/* NPCR-SPECIFIC FIELD FOR EARLY CASE CAPTURE/CHILDHOOD CANCER */
input @1361 N16_12010 $char1.  @; label N16_12010 ='12010_ECC Flag';  /*New*/
  
 
/* CONTINUE WITH NAACCR INCIDENCE LAYOUT */                        
input @1436 N16_1260 $char8.  @; label N16_1260 ='1260_Date Initial RX SEER'; 
input @1444 N16_1261 $char2.  @; label N16_1261 ='1261_Date Initial RX SEER Flag';  
input @1446 N16_1270 $char8.  @; label N16_1270 ='1270_Date 1st Crs RX CoC';  
input @1454 N16_1271 $char2.  @; label N16_1271 ='1271_Date 1st Crs RX CoC Flag';   
input @1456 N16_1200 $char8.  @; label N16_1200 ='1200_RX Date Surgery';   
input @1464 N16_1201 $char2.  @; label N16_1201 ='1201_RX Date Surgery Flag'; 
input @1466 N16_3170 $char8.  @; label N16_3170 ='3170_RX Date Mst Defn Srg'; 
input @1474 N16_3171 $char2.  @; label N16_3171 ='3171_RX Date Mst Defn Srg Flag';  
input @1476 N16_3180 $char8.  @; label N16_3180 ='3180_RX Date Surg Disch';   
input @1484 N16_3181 $char2.  @; label N16_3181 ='3181_RX Date Surg Disch Flag'; 
input @1486 N16_1210 $char8.  @; label N16_1210 ='1210_RX Date Radiation'; 
input @1494 N16_1211 $char2.  @; label N16_1211 ='1211_RX Date Radiation Flag';  
input @1496 N16_3220 $char8.  @; label N16_3220 ='3220_RX Date Rad Ended'; 
input @1504 N16_3221 $char2.  @; label N16_3221 ='3221_RX Date Rad Ended Flag';  
input @1506 N16_3230 $char8.  @; label N16_3230 ='3230_RX Date Systemic';  
input @1514 N16_3231 $char2.  @; label N16_3231 ='3231_RX Date Systemic Flag';   
input @1516 N16_1220 $char8.  @; label N16_1220 ='1220_RX Date Chemo';  
input @1524 N16_1221 $char2.  @; label N16_1221 ='1221_RX Date Chemo Flag';   
input @1526 N16_1230 $char8.  @; label N16_1230 ='1230_RX Date Hormone';   
input @1534 N16_1231 $char2.  @; label N16_1231 ='1231_RX Date Hormone Flag'; 
input @1536 N16_1240 $char8.  @; label N16_1240 ='1240_RX Date BRM'; 
input @1544 N16_1241 $char2.  @; label N16_1241 ='1241_RX Date BRM Flag';  
input @1546 N16_1250 $char8.  @; label N16_1250 ='1250_RX Date Other';  
input @1554 N16_1251 $char2.  @; label N16_1251 ='1251_RX Date Other Flag';   
input @1556 N16_1280 $char8.  @; label N16_1280 ='1280_RX Date DX/Stg Proc';  
input @1564 N16_1281 $char2.  @; label N16_1281 ='1281_RX Date DX/Stg Proc Flag';   
input @1566 N16_1285 $char1.  @; label N16_1285 ='1285_RX Summ--Treatment Status';  
input @1567 N16_1290 $char2.  @; label N16_1290 ='1290_RX Summ--Surg Prim Site'; 
input @1569 N16_1292 $char1.  @; label N16_1292 ='1292_RX Summ--Scope Reg LN Sur';  
input @1570 N16_1294 $char1.  @; label N16_1294 ='1294_RX Summ--Surg Oth Reg/Dis';  
input @1571 N16_1296 $char2.  @; label N16_1296 ='1296_RX Summ--Reg LN Examined';   
input @1573 N16_1310 $char1.  @; label N16_1310 ='1310_RX Summ--Surgical Approch';  
input @1574 N16_1320 $char1.  @; label N16_1320 ='1320_RX Summ--Surgical Margins';  
input @1575 N16_1330 $char1.  @; label N16_1330 ='1330_RX Summ--Reconstruct 1st';   
input @1576 N16_1340 $char1.  @; label N16_1340 ='1340_Reason for No Surgery';   
input @1577 N16_1350 $char2.  @; label N16_1350 ='1350_RX Summ--DX/Stg Proc'; 
input @1579 N16_3270 $char1.  @; label N16_3270 ='3270_RX Summ--Palliative Proc';   
input @1580 N16_1360 $char1.  @; label N16_1360 ='1360_RX Summ--Radiation';   
input @1581 N16_1370 $char1.  @; label N16_1370 ='1370_RX Summ--Rad to CNS';  
input @1582 N16_1380 $char1.  @; label N16_1380 ='1380_RX Summ--Surg/Rad Seq';   
input @1583 N16_3250 $char2.  @; label N16_3250 ='3250_RX Summ--Transplnt/Endocr';  
input @1585 N16_1390 $char2.  @; label N16_1390 ='1390_RX Summ--Chemo'; 
input @1587 N16_1400 $char2.  @; label N16_1400 ='1400_RX Summ--Hormone';  
input @1589 N16_1410 $char2.  @; label N16_1410 ='1410_RX Summ--BRM';   
input @1591 N16_1420 $char1.  @; label N16_1420 ='1420_RX Summ--Other'; 
input @1592 N16_1430 $char1.  @; label N16_1430 ='1430_Reason for No Radiation'; 
input @1593 N16_1460 $char2.  @; label N16_1460 ='1460_RX Coding System--Current';  
*input   @1595 N16_2161 $char1.  @; *label   N16_2161 ='2161_Reserved 18'; 
input @1596 N16_1510 $char5.  @; label N16_1510 ='1510_Rad--Regional Dose: cGy'; 
input @1601 N16_1520 $char3.  @; label N16_1520 ='1520_Rad--No of Treatment Vol';   
input @1604 N16_1540 $char2.  @; label N16_1540 ='1540_Rad--Treatment Volume';   
input @1606 N16_1550 $char1.  @; label N16_1550 ='1550_Rad--Location of RX';  
input @1607 N16_1570 $char2.  @; label N16_1570 ='1570_Rad--Regional RX Modality';  
input @1609 N16_3200 $char2.  @; label N16_3200 ='3200_Rad--Boost RX Modality';  
input @1611 N16_3210 $char5.  @; label N16_3210 ='3210_Rad--Boost Dose cGy';  
input @1616 N16_1639 $char1.  @; label N16_1639 ='1639_RX Summ--Systemic/Sur Seq';  
input @1617 N16_1640 $char2.  @; label N16_1640 ='1640_RX Summ--Surgery Type';   
input @1619 N16_3190 $char1.  @; label N16_3190 ='3190_Readm Same Hosp 30 Days'; 
input @1620 N16_1646 $char2.  @; label N16_1646 ='1646_RX Summ--Surg Site 98-02';   
input @1622 N16_1647 $char1.  @; label N16_1647 ='1647_RX Summ--Scope Reg 98-02';   
input @1623 N16_1648 $char1.  @; label N16_1648 ='1648_RX Summ--Surg Oth 98-02'; 
*input   @1624 N16_1190 $char100.   @; *label   N16_1190 ='1190_Reserved 06'; 
input @1724 N16_1660 $char8.  @; label N16_1660 ='1660_Subsq RX 2nd Course Date';   
input @1732 N16_1661 $char2.  @; label N16_1661 ='1661_Subsq RX 2ndCrs Date Flag';  
input @1734 N16_1670 $char11. @; label N16_1670 ='1670_Subsq RX 2nd Course Codes';  
input @1734 N16_1671 $char2.  @; label N16_1671 ='1671_Subsq RX 2nd Course Surg';   
input @1736 N16_1677 $char1.  @; label N16_1677 ='1677_Subsq RX 2nd--Scope LN SU';  
input @1737 N16_1678 $char1.  @; label N16_1678 ='1678_Subsq RX 2nd--Surg Oth';  
input @1738 N16_1679 $char2.  @; label N16_1679 ='1679_Subsq RX 2nd--Reg LN Rem';   
input @1740 N16_1672 $char1.  @; label N16_1672 ='1672_Subsq RX 2nd Course Rad'; 
input @1741 N16_1673 $char1.  @; label N16_1673 ='1673_Subsq RX 2nd Course Chemo';  
input @1742 N16_1674 $char1.  @; label N16_1674 ='1674_Subsq RX 2nd Course Horm';   
input @1743 N16_1675 $char1.  @; label N16_1675 ='1675_Subsq RX 2nd Course BRM'; 
input @1744 N16_1676 $char1.  @; label N16_1676 ='1676_Subsq RX 2nd Course Oth'; 
input @1745 N16_1680 $char8.  @; label N16_1680 ='1680_Subsq RX 3rd Course Date';   
input @1753 N16_1681 $char2.  @; label N16_1681 ='1681_Subsq RX 3rdCrs Date Flag';  
input @1755 N16_1690 $char11. @; label N16_1690 ='1690_Subsq RX 3rd Course Codes';  
input @1755 N16_1691 $char2.  @; label N16_1691 ='1691_Subsq RX 3rd Course Surg';   
input @1757 N16_1697 $char1.  @; label N16_1697 ='1697_Subsq RX 3rd--Scope LN Su';  
input @1758 N16_1698 $char1.  @; label N16_1698 ='1698_Subsq RX 3rd--Surg Oth';  
input @1759 N16_1699 $char2.  @; label N16_1699 ='1699_Subsq RX 3rd--Reg LN Rem';   
input @1761 N16_1692 $char1.  @; label N16_1692 ='1692_Subsq RX 3rd Course Rad'; 
input @1762 N16_1693 $char1.  @; label N16_1693 ='1693_Subsq RX 3rd Course Chemo';  
input @1763 N16_1694 $char1.  @; label N16_1694 ='1694_Subsq RX 3rd Course Horm';   
input @1764 N16_1695 $char1.  @; label N16_1695 ='1695_Subsq RX 3rd Course BRM'; 
input @1765 N16_1696 $char1.  @; label N16_1696 ='1696_Subsq RX 3rd Course Oth'; 
input @1766 N16_1700 $char8.  @; label N16_1700 ='1700_Subsq RX 4th Course Date';   
input @1774 N16_1701 $char2.  @; label N16_1701 ='1701_Subsq RX 4thCrs Date Flag';  
input @1776 N16_1710 $char11. @; label N16_1710 ='1710_Subsq RX 4th Course Codes';  
input @1776 N16_1711 $char2.  @; label N16_1711 ='1711_Subsq RX 4th Course Surg';   
input @1778 N16_1717 $char1.  @; label N16_1717 ='1717_Subsq RX 4th--Scope LN Su';  
input @1779 N16_1718 $char1.  @; label N16_1718 ='1718_Subsq RX 4th--Surg Oth';  
input @1780 N16_1719 $char2.  @; label N16_1719 ='1719_Subsq RX 4th--Reg LN Rem';   
input @1782 N16_1712 $char1.  @; label N16_1712 ='1712_Subsq RX 4th Course Rad'; 
input @1783 N16_1713 $char1.  @; label N16_1713 ='1713_Subsq RX 4th Course Chemo';  
input @1784 N16_1714 $char1.  @; label N16_1714 ='1714_Subsq RX 4th Course Horm';   
input @1785 N16_1715 $char1.  @; label N16_1715 ='1715_Subsq RX 4th Course BRM'; 
input @1786 N16_1716 $char1.  @; label N16_1716 ='1716_Subsq RX 4th Course Oth'; 
input @1787 N16_1741 $char1.  @; label N16_1741 ='1741_Subsq RX--Reconstruct Del';  
*input   @1788 N16_1300 $char100.   @; *label   N16_1300 ='1300_Reserved 07'; 
input @1888 N16_1981 $char1.  @; label N16_1981 ='1981_Over-ride SS/NodesPos';   
input @1889 N16_1982 $char1.  @; label N16_1982 ='1982_Over-ride SS/TNM-N';   
input @1890 N16_1983 $char1.  @; label N16_1983 ='1983_Over-ride SS/TNM-M';   
input @1891 N16_1985 $char1.  @; label N16_1985 ='1985_Over-ride Acsn/Class/Seq';   
input @1892 N16_1986 $char1.  @; label N16_1986 ='1986_Over-ride HospSeq/DxConf';   
input @1893 N16_1987 $char1.  @; label N16_1987 ='1987_Over-ride CoC-Site/Type'; 
input @1894 N16_1988 $char1.  @; label N16_1988 ='1988_Over-ride HospSeq/Site';  
input @1895 N16_1989 $char1.  @; label N16_1989 ='1989_Over-ride Site/TNM-StgGrp';  
input @1896 N16_1990 $char1.  @; label N16_1990 ='1990_Over-ride Age/Site/Morph';   
input @1897 N16_2000 $char1.  @; label N16_2000 ='2000_Over-ride SeqNo/DxConf';  
input @1898 N16_2010 $char1.  @; label N16_2010 ='2010_Over-ride Site/Lat/SeqNo';   
input @1899 N16_2020 $char1.  @; label N16_2020 ='2020_Over-ride Surg/DxConf';   
input @1900 N16_2030 $char1.  @; label N16_2030 ='2030_Over-ride Site/Type';  
input @1901 N16_2040 $char1.  @; label N16_2040 ='2040_Over-ride Histology';  
input @1902 N16_2050 $char1.  @; label N16_2050 ='2050_Over-ride Report Source'; 
input @1903 N16_2060 $char1.  @; label N16_2060 ='2060_Over-ride Ill-define Site';  
input @1904 N16_2070 $char1.  @; label N16_2070 ='2070_Over-ride Leuk, Lymphoma';   
input @1905 N16_2071 $char1.  @; label N16_2071 ='2071_Over-ride Site/Behavior'; 
input @1906 N16_2072 $char1.  @; label N16_2072 ='2072_Over-ride Site/EOD/DX Dt';   
input @1907 N16_2073 $char1.  @; label N16_2073 ='2073_Over-ride Site/Lat/EOD';  
input @1908 N16_2074 $char1.  @; label N16_2074 ='2074_Over-ride Site/Lat/Morph';   
input @1909 N16_1960 $char4.  @; label N16_1960 ='1960_Site (73-91) ICD-O-1'; 
input @1913 N16_1970 $char6.  @; label N16_1970 ='1970_Morph (73-91) ICD-O-1';   
input @1913 N16_1971 $char4.  @; label N16_1971 ='1971_Histology (73-91) ICD-O-1';  
input @1917 N16_1972 $char1.  @; label N16_1972 ='1972_Behavior (73-91) ICD-O-1';   
input @1918 N16_1973 $char1.  @; label N16_1973 ='1973_Grade (73-91) ICD-O-1';   
input @1919 N16_1980 $char1.  @; label N16_1980 ='1980_ICD-O-2 Conversion Flag'; 
input @1920 N16_2081 $char10. @; label N16_2081 ='2081_CRC CHECKSUM';   
input @1930 N16_2120 $char1.  @; label N16_2120 ='2120_SEER Coding Sys--Current';   
input @1931 N16_2130 $char1.  @; label N16_2130 ='2130_SEER Coding Sys--Original';  
input @1932 N16_2140 $char2.  @; label N16_2140 ='2140_CoC Coding Sys--Current'; 
input @1934 N16_2150 $char2.  @; label N16_2150 ='2150_CoC Coding Sys--Original';   
input @1936 N16_2170 $char10. @; label N16_2170 ='2170_Vendor Name'; 
input @1946 N16_2180 $char1.  @; label N16_2180 ='2180_SEER Type of Follow-Up';  
input @1947 N16_2190 $char2.  @; label N16_2190 ='2190_SEER Record Number';   
input @1949 N16_2200 $char2.  @; label N16_2200 ='2200_Diagnostic Proc 73-87';   
input @1951 N16_2085 $char8.  @; label N16_2085 ='2085_Date Case Initiated';  
input @1959 N16_2090 $char8.  @; label N16_2090 ='2090_Date Case Completed';  
input @1967 N16_2092 $char8.  @; label N16_2092 ='2092_Date Case Completed--CoC';   
input @1975 N16_2100 $char8.  @; label N16_2100 ='2100_Date Case Last Changed';  
input @1983 N16_2110 $char8.  @; label N16_2110 ='2110_Date Case Report Exported';  
input @1991 N16_2111 $char8.  @; label N16_2111 ='2111_Date Case Report Received';  
input @1999 N16_2112 $char8.  @; label N16_2112 ='2112_Date Case Report Loaded'; 
input @2007 N16_2113 $char8.  @; label N16_2113 ='2113_Date Tumor Record Availbl';  
input @2015 N16_2116 $char1.  @; label N16_2116 ='2116_ICD-O-3 Conversion Flag'; 
input @2016 N16_3750 $char1.  @; label N16_3750 ='3750_Over-ride CS 1'; 
input @2017 N16_3751 $char1.  @; label N16_3751 ='3751_Over-ride CS 2'; 
input @2018 N16_3752 $char1.  @; label N16_3752 ='3752_Over-ride CS 3'; 
input @2019 N16_3753 $char1.  @; label N16_3753 ='3753_Over-ride CS 4'; 
input @2020 N16_3754 $char1.  @; label N16_3754 ='3754_Over-ride CS 5'; 
input @2021 N16_3755 $char1.  @; label N16_3755 ='3755_Over-ride CS 6'; 
input @2022 N16_3756 $char1.  @; label N16_3756 ='3756_Over-ride CS 7'; 
input @2023 N16_3757 $char1.  @; label N16_3757 ='3757_Over-ride CS 8'; 
input @2024 N16_3758 $char1.  @; label N16_3758 ='3758_Over-ride CS 9'; 
input @2025 N16_3759 $char1.  @; label N16_3759 ='3759_Over-ride CS 10';   
input @2026 N16_3760 $char1.  @; label N16_3760 ='3760_Over-ride CS 11';   
input @2027 N16_3761 $char1.  @; label N16_3761 ='3761_Over-ride CS 12';   
input @2028 N16_3762 $char1.  @; label N16_3762 ='3762_Over-ride CS 13';   
input @2029 N16_3763 $char1.  @; label N16_3763 ='3763_Over-ride CS 14';   
input @2030 N16_3764 $char1.  @; label N16_3764 ='3764_Over-ride CS 15';   
input @2031 N16_3765 $char1.  @; label N16_3765 ='3765_Over-ride CS 16';   
input @2032 N16_3766 $char1.  @; label N16_3766 ='3766_Over-ride CS 17';   
input @2033 N16_3767 $char1.  @; label N16_3767 ='3767_Over-ride CS 18';   
input @2034 N16_3768 $char1.  @; label N16_3768 ='3768_Over-ride CS 19';   
input @2035 N16_3769 $char1.  @; label N16_3769 ='3769_Over-ride CS 20';   
*input   @2036 N16_1650 $char80. @; *label   N16_1650 ='1650_Reserved 08'; 
input @2116 N16_1750 $char8.  @; label N16_1750 ='1750_Date of Last Contact'; 
input @2124 N16_1751 $char2.  @; label N16_1751 ='1751_Date of Last Contact Flag';  
input @2126 N16_1760 $char1.  @; label N16_1760 ='1760_Vital Status';   
input @2127 N16_1770 $char1.  @; label N16_1770 ='1770_Cancer Status';  
input @2128 N16_1780 $char1.  @; label N16_1780 ='1780_Quality of Survival';  
input @2129 N16_1790 $char1.  @; label N16_1790 ='1790_Follow-Up Source';  
input @2130 N16_1800 $char1.  @; label N16_1800 ='1800_Next Follow-Up Source';   
input @2131 N16_1810 $char50. @; label N16_1810 ='1810_Addr Current--City';   
input @2181 N16_1820 $char2.  @; label N16_1820 ='1820_Addr Current--State';  
input @2183 N16_1830 $char9.  @; label N16_1830 ='1830_Addr Current--Postal Code';  
input @2192 N16_1840 $char3.  @; label N16_1840 ='1840_County--Current';   
*input   @2195 N16_2700 $char1.  @; *label   N16_2700 ='2700_Reserved 17'; 
input @2196 N16_1860 $char8.  @; label N16_1860 ='1860_Recurrence Date--1st'; 
input @2204 N16_1861 $char2.  @; label N16_1861 ='1861_Recurrence Date--1st Flag';  
input @2206 N16_1880 $char2.  @; label N16_1880 ='1880_Recurrence Type--1st'; 
input @2208 N16_1842 $char50. @; label N16_1842 ='1842_Follow-Up Contact--City'; 
input @2258 N16_1844 $char2.  @; label N16_1844 ='1844_Follow-Up Contact--State';   
input @2260 N16_1846 $char9.  @; label N16_1846 ='1846_Follow-Up Contact--Postal';  
input @2269 N16_1910 $char4.  @; label N16_1910 ='1910_Cause of Death'; 
input @2273 N16_1920 $char1.  @; label N16_1920 ='1920_ICD Revision Number';  
input @2274 N16_1930 $char1.  @; label N16_1930 ='1930_Autopsy';  
input @2275 N16_1940 $char3.  @; label N16_1940 ='1940_Place of Death'; 
input @2278 N16_1791 $char2.  @; label N16_1791 ='1791_Follow-up Source Central';   
input @2280 N16_1755 $char8.  @; label N16_1755 ='1755_Date of Death--Canada';   
input @2288 N16_1756 $char2.  @; label N16_1756 ='1756_Date of Death--CanadaFlag';  
input @2290 N16_1850 $char2.  @; label N16_1850 ='1850_Unusual Follow-Up Method';   
input @2292 N16_1782 $char8.  @; label N16_1782 ='1782_Surv-Date Active Followup';  
input @2300 N16_1783 $char1.  @; label N16_1783 ='1783_Surv-Flag Active Followup';  
input @2301 N16_1784 $char4.  @; label N16_1784 ='1784_Surv-Mos Active Followup';   
input @2305 N16_1785 $char8.  @; label N16_1785 ='1785_Surv-Date Presumed Alive';   
input @2313 N16_1786 $char1.  @; label N16_1786 ='1786_Surv-Flag Presumed Alive';   
input @2314 N16_1787 $char4.  @; label N16_1787 ='1787_Surv-Mos Presumed Alive'; 
input @2318 N16_1788 $char8.  @; label N16_1788 ='1788_Surv-Date DX Recode';  
*input   @2326 N16_1740 $char14.   @; *label N16_1740 ='1740_Reserved 09';
*input   @2340 N16_2220 $char1000. @; *label N16_2220 ='2220_State/Requestor Items'; 
  
                        
/* CONFIDENTIAL LAYOUT 5564 */                        
input @3340 N16_2230 $char40. @; label N16_2230 ='2230_Name--Last';  
input @3380 N16_2240 $char40. @; label N16_2240 ='2240_Name--First'; 
input @3420 N16_2250 $char40. @; label N16_2250 ='2250_Name--Middle';   
input @3460 N16_2260 $char3.  @; label N16_2260 ='2260_Name--Prefix';   
input @3463 N16_2270 $char3.  @; label N16_2270 ='2270_Name--Suffix';   
input @3466 N16_2280 $char40. @; label N16_2280 ='2280_Name--Alias'; 
input @3506 N16_2390 $char40. @; label N16_2390 ='2390_Name--Maiden';   
input @3546 N16_2290 $char60. @; label N16_2290 ='2290_Name--Spouse/Parent';  
input @3606 N16_2300 $char11. @; label N16_2300 ='2300_Medical Record Number';   
input @3617 N16_2310 $char2.  @; label N16_2310 ='2310_Military Record No Suffix';  
input @3619 N16_2320 $char9.  @; label N16_2320 ='2320_Social Security Number';  
input @3628 N16_2330 $char60. @; label N16_2330 ='2330_Addr at DX--No & Street'; 
input @3688 N16_2335 $char60. @; label N16_2335 ='2335_Addr at DX--Supplementl'; 
input @3748 N16_2350 $char60. @; label N16_2350 ='2350_Addr Current--No & Street';  
input @3808 N16_2355 $char60. @; label N16_2355 ='2355_Addr Current--Supplementl';  
input @3868 N16_2360 $char10. @; label N16_2360 ='2360_Telephone';   
input @3878 N16_2380 $char6.  @; label N16_2380 ='2380_DC State File Number'; 
input @3884 N16_2394 $char60. @; label N16_2394 ='2394_Follow-Up Contact--Name'; 
input @3944 N16_2392 $char60. @; label N16_2392 ='2392_Follow-Up Contact--No&St';   
input @4004 N16_2393 $char60. @; label N16_2393 ='2393_Follow-Up Contact--Suppl';   
input @4064 N16_2352 $char10. @; label N16_2352 ='2352_Latitude'; 
input @4074 N16_2354 $char11. @; label N16_2354 ='2354_Longitude';   
*input   @4085 N16_1835 $char200.   @; *label   N16_1835 ='1835_Reserved 10'; 
input @4285 N16_2445 $char10. @; label N16_2445 ='2445_NPI--Following Registry'; 
input @4295 N16_2440 $char10. @; label N16_2440 ='2440_Following Registry';   
input @4305 N16_2415 $char10. @; label N16_2415 ='2415_NPI--Inst Referred From'; 
input @4315 N16_2410 $char10. @; label N16_2410 ='2410_Institution Referred From';  
input @4325 N16_2425 $char10. @; label N16_2425 ='2425_NPI--Inst Referred To';   
input @4335 N16_2420 $char10. @; label N16_2420 ='2420_Institution Referred To'; 
*input   @4345 N16_1900 $char50. @; *label   N16_1900 ='1900_Reserved 11'; 
input @4395 N16_2465 $char10. @; label N16_2465 ='2465_NPI--Physician--Managing';   
input @4405 N16_2460 $char8.  @; label N16_2460 ='2460_Physician--Managing';  
input @4413 N16_2475 $char10. @; label N16_2475 ='2475_NPI--Physician--Follow-Up';  
input @4423 N16_2470 $char8.  @; label N16_2470 ='2470_Physician--Follow-Up'; 
input @4431 N16_2485 $char10. @; label N16_2485 ='2485_NPI--Physician--Primary Surg';  
input @4441 N16_2480 $char8.  @; label N16_2480 ='2480_Physician--Primary Surg'; 
input @4449 N16_2495 $char10. @; label N16_2495 ='2495_NPI--Physician 3';  
input @4459 N16_2490 $char8.  @; label N16_2490 ='2490_Physician 3'; 
input @4467 N16_2505 $char10. @; label N16_2505 ='2505_NPI--Physician 4';  
input @4477 N16_2500 $char8.  @; label N16_2500 ='2500_Physician 4'; 
input @4535 N16_7010 $char25. @; label N16_7010 ='7010_Path Reporting Fac ID 1'; 
input @4560 N16_7090 $char20. @; label N16_7090 ='7090_Path Report Number 1'; 
input @4580 N16_7320 $char14. @; label N16_7320 ='7320_Path Date Spec Collect 1';   
input @4594 N16_7480 $char2.  @; label N16_7480 ='7480_Path Report Type 1';   
input @4596 N16_7190 $char25. @; label N16_7190 ='7190_Path Ordering Fac No 1';  
input @4621 N16_7100 $char20. @; label N16_7100 ='7100_Path Order Phys Lic No 1';   
input @4641 N16_7011 $char25. @; label N16_7011 ='7011_Path Reporting Fac ID 2'; 
input @4666 N16_7091 $char20. @; label N16_7091 ='7091_Path Report Number 2'; 
input @4686 N16_7321 $char14. @; label N16_7321 ='7321_Path Date Spec Collect 2';   
input @4700 N16_7481 $char2.  @; label N16_7481 ='7481_Path Report Type 2';   
input @4702 N16_7191 $char25. @; label N16_7191 ='7191_Path Ordering Fac No 2';  
input @4727 N16_7101 $char20. @; label N16_7101 ='7101_Path Order Phys Lic No 2';   
input @4747 N16_7012 $char25. @; label N16_7012 ='7012_Path Reporting Fac ID 3'; 
input @4772 N16_7092 $char20. @; label N16_7092 ='7092_Path Report Number 3'; 
input @4792 N16_7322 $char14. @; label N16_7322 ='7322_Path Date Spec Collect 3';   
input @4806 N16_7482 $char2.  @; label N16_7482 ='7482_Path Report Type 3';   
input @4808 N16_7192 $char25. @; label N16_7192 ='7192_Path Ordering Fac No 3';  
input @4833 N16_7102 $char20. @; label N16_7102 ='7102_Path Order Phys Lic No 3';   
input @4853 N16_7013 $char25. @; label N16_7013 ='7013_Path Reporting Fac ID 4'; 
input @4878 N16_7093 $char20. @; label N16_7093 ='7093_Path Report Number 4'; 
input @4898 N16_7323 $char14. @; label N16_7323 ='7323_Path Date Spec Collect 4';   
input @4912 N16_7483 $char2.  @; label N16_7483 ='7483_Path Report Type 4';   
input @4914 N16_7193 $char25. @; label N16_7193 ='7193_Path Ordering Fac No 4';  
input @4939 N16_7103 $char20. @; label N16_7103 ='7103_Path Order Phys Lic No 4';   
input @4959 N16_7014 $char25. @; label N16_7014 ='7014_Path Reporting Fac ID 5'; 
input @4984 N16_7094 $char20. @; label N16_7094 ='7094_Path Report Number 5'; 
input @5004 N16_7324 $char14. @; label N16_7324 ='7324_Path Date Spec Collect 5';   
input @5018 N16_7484 $char2.  @; label N16_7484 ='7484_Path Report Type 5';   
input @5020 N16_7194 $char25. @; label N16_7194 ='7194_Path Ordering Fac No 5';  
input @5045 N16_7104 $char20. @; label N16_7104 ='7104_Path Order Phys Lic No 5';   
*input   @5065 N16_2080 $char500.   @; *label   N16_2080 ='2080_Reserved 13'; 


/* NPCR CER & PCOR VARIABLES - ONLY FOR CER & PCOR STATES */
input @5065 N16_8000 $char8.  @; label N16_8000 ='8000_Active Follow-Up Date';   
input @5073 N16_8002 $char8.  @; label N16_8002 ='8002_Comp1stCrsRxDt'; 
input @5081 N16_8005 $char8.  @; label N16_8005 ='8005_FrstDsFreeDt';   
input @5089 N16_8008 $char8.  @; label N16_8008 ='8008_LstDsFreeDt'; 
input @5097 N16_8011 $char8.  @; label N16_8011 ='8011_FrstRecDt';   
input @5105 N16_8015 $char8.  @; label N16_8015 ='8015_ProgressionDt';  
input @5113 N16_8018 $char8.  @; label N16_8018 ='8018_SubseqPrmryDt';  
input @5121 N16_8020 $char8.  @; label N16_8020 ='8020_PCOR_SubseqRx2ndCrsDt';   
input @5129 N16_8021 $char2.  @; label N16_8021 ='8021_PCOR_SubseqRx2ndCrsDtFlag';  
input @5133 N16_9751 $char6.  @; label N16_9751 ='9751_Chemo 1 NSC Number';   
input @5139 N16_9761 $char2.  @; label N16_9761 ='9761_Chemo 1 Num Doses Planned';  
input @5141 N16_9771 $char6.  @; label N16_9771 ='9771_Chemo 1 Planned Dose'; 
input @5147 N16_9781 $char2.  @; label N16_9781 ='9781_Chemo 1 Planned Dose Unit';  
input @5149 N16_9791 $char2.  @; label N16_9791 ='9791_Chemo 1 Num Doses Receivd';  
input @5151 N16_9801 $char6.  @; label N16_9801 ='9801_Chemo 1 Received Dose';   
input @5157 N16_9811 $char2.  @; label N16_9811 ='9811_Chemo 1 Received DoseUnit';  
input @5159 N16_9821 $char8.  @; label N16_9821 ='9821_Chemo 1 Start Date';   
input @5167 N16_9831 $char2.  @; label N16_9831 ='9831_Chemo 1 Start Date Flag'; 
input @5169 N16_9841 $char8.  @; label N16_9841 ='9841_Chemo 1 End Date';  
input @5177 N16_9851 $char2.  @; label N16_9851 ='9851_Chemo 1 End Date Flag';   
input @5179 N16_9752 $char6.  @; label N16_9752 ='9752_Chemo 2 NSC Number';   
input @5185 N16_9762 $char2.  @; label N16_9762 ='9762_Chemo 2 Num Doses Planned';  
input @5187 N16_9772 $char6.  @; label N16_9772 ='9772_Chemo 2 Planned Dose'; 
input @5193 N16_9782 $char2.  @; label N16_9782 ='9782_Chemo 2 Planned Dose Unit';  
input @5195 N16_9792 $char2.  @; label N16_9792 ='9792_Chemo 2 Num Doses Receivd';  
input @5197 N16_9802 $char6.  @; label N16_9802 ='9802_Chemo 2 Received Dose';   
input @5203 N16_9812 $char2.  @; label N16_9812 ='9812_Chemo 2 Received DoseUnit';  
input @5205 N16_9822 $char8.  @; label N16_9822 ='9822_Chemo 2 Start Date';   
input @5213 N16_9832 $char2.  @; label N16_9832 ='9832_Chemo 2 Start Date Flag'; 
input @5215 N16_9842 $char8.  @; label N16_9842 ='9842_Chemo 2 End Date';  
input @5223 N16_9852 $char2.  @; label N16_9852 ='9852_Chemo 2 End Date Flag';   
input @5225 N16_9900 $char3.  @; label N16_9900 ='9900_BCR-ABL Cytogenetic';  
input @5228 N16_9901 $char8.  @; label N16_9901 ='9901_BCR-ABL Cytogenetic Date';   
input @5236 N16_9902 $char2.  @; label N16_9902 ='9902_BCR-ABL Cytogen Date Flag';  
input @5238 N16_9903 $char3.  @; label N16_9903 ='9903_BCR-ABL FISH';   
input @5241 N16_9904 $char8.  @; label N16_9904 ='9904_BCR-ABL FISH Date'; 
input @5249 N16_9905 $char2.  @; label N16_9905 ='9905_BCR-ABL FISH Date Flag';  
input @5251 N16_9906 $char3.  @; label N16_9906 ='9906_BCR-ABL RT-PCR Qual';  
input @5254 N16_9907 $char8.  @; label N16_9907 ='9907_BCR-ABL RT-PCR Qual Date';   
input @5262 N16_9908 $char2.  @; label N16_9908 ='9908_BCR-ABL RT-PCR Qual DtFlg';  
input @5264 N16_9909 $char3.  @; label N16_9909 ='9909_BCR-ABL RT-PCR Quant'; 
input @5267 N16_9910 $char8.  @; label N16_9910 ='9910_BCR-ABL RT-PCR Quant Date';  
input @5275 N16_9911 $char2.  @; label N16_9911 ='9911_BCR-ABL RT-PCR Quan DtFlg';  
input @5277 N16_9753 $char6.  @; label N16_9753 ='9753_Chemo 3 NSC Number';   
input @5283 N16_9763 $char2.  @; label N16_9763 ='9763_Chemo 3 Num Doses Planned';  
input @5285 N16_9773 $char6.  @; label N16_9773 ='9773_Chemo 3 Planned Dose'; 
input @5291 N16_9783 $char2.  @; label N16_9783 ='9783_Chemo 3 Planned Dose Unit';  
input @5293 N16_9793 $char2.  @; label N16_9793 ='9793_Chemo 3 Num Doses Receivd';  
input @5295 N16_9803 $char6.  @; label N16_9803 ='9803_Chemo 3 Received Dose';   
input @5301 N16_9813 $char2.  @; label N16_9813 ='9813_Chemo 3 Received DoseUnit';  
input @5303 N16_9823 $char8.  @; label N16_9823 ='9823_Chemo 3 Start Date';   
input @5311 N16_9833 $char2.  @; label N16_9833 ='9833_Chemo 3 Start Date Flag'; 
input @5313 N16_9843 $char8.  @; label N16_9843 ='9843_Chemo 3 End Date';  
input @5321 N16_9853 $char2.  @; label N16_9853 ='9853_Chemo 3 End Date Flag';   
input @5323 N16_9754 $char6.  @; label N16_9754 ='9754_Chemo 4 NSC Number';   
input @5329 N16_9764 $char2.  @; label N16_9764 ='9764_Chemo 4 Num Doses Planned';  
input @5331 N16_9774 $char6.  @; label N16_9774 ='9774_Chemo 4 Planned Dose'; 
input @5337 N16_9784 $char2.  @; label N16_9784 ='9784_Chemo 4 Planned Dose Unit';  
input @5339 N16_9794 $char2.  @; label N16_9794 ='9794_Chemo 4 Num Doses Receivd';  
input @5341 N16_9804 $char6.  @; label N16_9804 ='9804_Chemo 4 Received Dose';   
input @5347 N16_9814 $char2.  @; label N16_9814 ='9814_Chemo 4 Received DoseUnit';  
input @5349 N16_9824 $char8.  @; label N16_9824 ='9824_Chemo 4 Start Date';   
input @5357 N16_9834 $char2.  @; label N16_9834 ='9834_Chemo 4 Start Date Flag'; 
input @5359 N16_9844 $char8.  @; label N16_9844 ='9844_Chemo 4 End Date';  
input @5367 N16_9854 $char2.  @; label N16_9854 ='9854_Chemo 4 End Date Flag';   
input @5369 N16_9755 $char6.  @; label N16_9755 ='9755_Chemo 5 NSC Number';   
input @5375 N16_9765 $char2.  @; label N16_9765 ='9765_Chemo 5 Num Doses Planned';  
input @5377 N16_9775 $char6.  @; label N16_9775 ='9775_Chemo 5 Planned Dose'; 
input @5383 N16_9785 $char2.  @; label N16_9785 ='9785_Chemo 5 Planned Dose Unit';  
input @5385 N16_9795 $char2.  @; label N16_9795 ='9795_Chemo 5 Num Doses Receivd';  
input @5387 N16_9805 $char6.  @; label N16_9805 ='9805_Chemo 5 Received Dose';   
input @5393 N16_9815 $char2.  @; label N16_9815 ='9815_Chemo 5 Received DoseUnit';  
input @5395 N16_9825 $char8.  @; label N16_9825 ='9825_Chemo 5 Start Date';   
input @5403 N16_9835 $char2.  @; label N16_9835 ='9835_Chemo 5 Start Date Flag'; 
input @5405 N16_9845 $char8.  @; label N16_9845 ='9845_Chemo 5 End Date';  
input @5413 N16_9855 $char2.  @; label N16_9855 ='9855_Chemo 5 End Date Flag';   
input @5415 N16_9756 $char6.  @; label N16_9756 ='9756_Chemo 6 NSC Number';   
input @5421 N16_9766 $char2.  @; label N16_9766 ='9766_Chemo 6 Num Doses Planned';  
input @5423 N16_9776 $char6.  @; label N16_9776 ='9776_Chemo 6 Planned Dose'; 
input @5429 N16_9786 $char2.  @; label N16_9786 ='9786_Chemo 6 Planned Dose Unit';  
input @5431 N16_9796 $char2.  @; label N16_9796 ='9796_Chemo 6 Num Doses Receivd';  
input @5433 N16_9806 $char6.  @; label N16_9806 ='9806_Chemo 6 Received Dose';   
input @5439 N16_9816 $char2.  @; label N16_9816 ='9816_Chemo 6 Received DoseUnit';  
input @5441 N16_9826 $char8.  @; label N16_9826 ='9826_Chemo 6 Start Date';   
input @5449 N16_9836 $char2.  @; label N16_9836 ='9836_Chemo 6 Start Date Flag'; 
input @5451 N16_9846 $char8.  @; label N16_9846 ='9846_Chemo 6 End Date';  
input @5459 N16_9856 $char2.  @; label N16_9856 ='9856_Chemo 6 End Date Flag';   
input @5461 N16_9859 $char1.  @; label N16_9859 ='9859_Chemo Completion Status'; 
input @5462 N16_9920 $char1.  @; label N16_9920 ='9920_Reason Subsq Rx';   
input @5463 N16_9921 $char2.  @; label N16_9921 ='9921_Subsq RX 2ndCrs Surg'; 
input @5465 N16_9922 $char2.  @; label N16_9922 ='9922_Subsq Rx 2ndCrs Rad';  
input @5467 N16_9923 $char2.  @; label N16_9923 ='9923_Subsq Rx 2ndCrs Chemo';   
input @5469 N16_9924 $char2.  @; label N16_9924 ='9924_Subsq Rx 2ndCrs Horm'; 
input @5471 N16_9925 $char2.  @; label N16_9925 ='9925_Subsq Rx 2ndCrs BRM';  
input @5473 N16_9926 $char1.  @; label N16_9926 ='9926_Subsq Rx 2ndCrs Oth';  
input @5474 N16_9927 $char2.  @; label N16_9927 ='9927_Subsq Rx 2ndCrs Trans/End';  
input @5476 N16_9931 $char6.  @; label N16_9931 ='9931_Subsq RX 2nd Chemo 1 NSC';   
input @5482 N16_9932 $char6.  @; label N16_9932 ='9932_Subsq RX 2nd Chemo 2 NSC';   
input @5488 N16_9933 $char6.  @; label N16_9933 ='9933_Subsq RX 2nd Chemo 3 NSC';   
input @5494 N16_9934 $char6.  @; label N16_9934 ='9934_Subsq RX 2nd Chemo 4 NSC';   
input @5500 N16_9935 $char6.  @; label N16_9935 ='9935_Subsq RX 2nd Chemo 5 NSC';   
input @5506 N16_9936 $char6.  @; label N16_9936 ='9936_Subsq RX 2nd Chemo 6 NSC';   
input @5512 N16_9941 $char6.  @; label N16_9941 ='9941_Subsq RX 2nd Horm 1 NSC'; 
input @5518 N16_9942 $char6.  @; label N16_9942 ='9942_Subsq RX 2nd Horm 2 NSC'; 
input @5524 N16_9951 $char6.  @; label N16_9951 ='9951_Subsq RX 2nd BRM 1 NSC';  
input @5530 N16_9952 $char6.  @; label N16_9952 ='9952_Subsq RX 2nd BRM 2 NSC';  
input @5536 N16_9955 $char2.  @; label N16_9955 ='9955_Subsq RX 2nd DateFlag CER';  
input @5538 N16_9861 $char6.  @; label N16_9861 ='9861_Hormone 1 NSC Number'; 
input @5544 N16_9862 $char6.  @; label N16_9862 ='9862_Hormone 2 NSC Number'; 
input @5550 N16_9871 $char6.  @; label N16_9871 ='9871_BRM 1 NSC';   
input @5556 N16_9872 $char6.  @; label N16_9872 ='9872_BRM 2 NSC';   
input @5562 N16_9880 $char1.  @; label N16_9880 ='9880_Granulocyte CSF Status';  
input @5563 N16_9881 $char1.  @; label N16_9881 ='9881_Erythro Growth Factor Sta';  
input @5564 N16_9882 $char1.  @; label N16_9882 ='9882_Thrombocyte GrowthFactSta';  
                        
                        
/* TEXT VARIABLES 22824 */      
input @5565    N16_2520 $char1000.  @; label N16_2520 ='2520_Text--DX Proc--PE'; 
input @6565    N16_2530 $char1000.  @; label N16_2530 ='2530_Text--DX Proc--X-ray/scan';  
input @7565    N16_2540 $char1000.  @; label N16_2540 ='2540_Text--DX Proc--Scopes';   
input @8565    N16_2550 $char1000.  @; label N16_2550 ='2550_Text--DX Proc--Lab Tests';   
input @9565    N16_2560 $char1000.  @; label N16_2560 ='2560_Text--DX Proc--Op'; 
input @10565   N16_2570 $char1000.  @; label N16_2570 ='2570_Text--DX Proc--Path';  
input @11565   N16_2580 $char100.   @; label N16_2580 ='2580_Text--Primary Site Title';   
input @11665   N16_2590 $char100.   @; label N16_2590 ='2590_Text--Histology Title';   
input @11765   N16_2600 $char1000.  @; label N16_2600 ='2600_Text--Staging';  
input @12765   N16_2610 $char1000.  @; label N16_2610 ='2610_RX Text--Surgery';  
input @13765   N16_2620 $char1000.  @; label N16_2620 ='2620_RX Text--Radiation (Beam)';  
input @14765   N16_2630 $char1000.  @; label N16_2630 ='2630_RX Text--Radiation Other';   
input @15765   N16_2640 $char1000.  @; label N16_2640 ='2640_RX Text--Chemo'; 
input @16765   N16_2650 $char1000.  @; label N16_2650 ='2650_RX Text--Hormone';  
input @17765   N16_2660 $char1000.  @; label N16_2660 ='2660_RX Text--BRM';   
input @18765   N16_2670 $char1000.  @; label N16_2670 ='2670_RX Text--Other'; 
input @19765   N16_2680 $char1000.  @; label N16_2680 ='2680_Text--Remarks';  
input @20765   N16_2690 $char60.    @; label N16_2690 ='2690_Text--Place Of Diagnosis';   
*input   @20825   N16_2210 $char2000.  @; *label   N16_2210 ='2210_Reserved 14'; 

/* ADDITIONAL USEFUL VARIABLES IN RECORD */
input @530 dx_year    $char4.   @;  label  dx_year   ='YEAR OF DIAGNOSIS';
input @534 dx_month   $char2.   @;  label  dx_month  ='MONTH OF DIAGNOSIS';
input @147 ZIPCode    $char5.   @;  label  ZIPCode   ='ZIP CODE 5-DIGIT';  

run;






data _NULL_;
   set SAStest;
* file outv16 lrecl= 3339 pad; /* INCIDENCE */
* file outv16 lrecl= 5564 pad; /* CONFIDENTIAL */
  file outv16 lrecl=22824 pad; /* TEXT */
put
/* Incidence record */              
   @  1     N16_10   $1.   
   @  2     N16_30   $1.   
/* @  3     N16_37   $14.  */
   @  17    N16_50   $3.   
   @  20    N16_45   $10.  
   @  30    N16_40   $10.  
   @  40    N16_60   $2.   
   @  42    N16_20   $8.   
   @  50    N16_21   $8.   
/* @  58  N16_370 $37.  */
   @  95    N16_70   $50.  
   @  145   N16_80   $2.   
   @  147   N16_100  $9.   
   @  156   N16_90   $3.   
   @  159   N16_110  $6.   
   @  165   N16_368  $1.   
   @  166   N16_120  $1.   
   @  167   N16_364  $1.   
   @  168   N16_130  $6.   
   @  174   N16_362  $1.   
   @  175   N16_365  $1.   
   @  176   N16_150  $1.   
   @  177   N16_160  $2.   
   @  179   N16_161  $2.   
   @  181   N16_162  $2.   
   @  183   N16_163  $2.   
   @  185   N16_164  $2.   
   @  187   N16_170  $1.   
   @  188   N16_180  $1.   
   @  189   N16_190  $1.   
   @  190   N16_200  $1.   
   @  191   N16_210  $1.   
   @  192   N16_220  $1.   
   @  193   N16_230  $3.   
   @  196   N16_240  $8.   
   @  204   N16_241  $2.   
   @  206   N16_250  $3.   
   @  209   N16_270  $3.   
   @  212   N16_280  $3.   
   @  215   N16_290  $1.   
   @  216   N16_300  $1.   
   @  217   N16_310  $100. 
   @  317   N16_320  $100. 
   @  417   N16_330  $1.   
   @  418   N16_191  $1.   
   @  419   N16_193  $2.   
   @  421   N16_192  $1.   
   @  422   N16_366  $2.   
   @  424   N16_3300 $2.   
   @  426   N16_3310 $2.   
   @  428   N16_135  $6.   
   @  434   N16_363  $1.   
   @  435   N16_367  $1.   
   @  436   N16_102  $3.   
   @  439   N16_1832 $3.   
   @  442   N16_252  $2.   
   @  444   N16_254  $3.   
   @  447   N16_1847 $3.   
   @  450   N16_1942 $2.   
   @  452   N16_1944 $3.   
   @  455   N16_272  $4.   
   @  459   N16_282  $4.   
   @  463   N16_145  $1.
   @  464   N16_94   $3.
   @  467   N16_95   $3.
   @  470   N16_96   $3.
   @  473   N16_97   $3.
   @  476   N16_3312 $2.
/* @  478   N16_530  $50.  */
   @  528   N16_380  $2.   
   @  530   N16_390  $8.   
   @  538   N16_391  $2.   
   @  540   N16_400  $4.   
   @  544   N16_410  $1.   
   @  545   N16_419  $5.   
   @  545   N16_420  $4.   
   @  549   N16_430  $1.   
   @  550   N16_521  $5.   
   @  550   N16_522  $4.   
   @  554   N16_523  $1.   
   @  555   N16_440  $1.   
   @  556   N16_441  $1.   
   @  557   N16_449  $1.   
   @  558   N16_450  $1.   
   @  559   N16_460  $1.   
   @  560   N16_470  $1.   
   @  561   N16_480  $1.   
   @  562   N16_490  $1.   
   @  563   N16_500  $1.   
   @  564   N16_501  $2.   
   @  566   N16_442  $1.   
   @  567   N16_443  $8.   
   @  575   N16_448  $2.   
   @  577   N16_444  $2.   
   @  579   N16_445  $8.   
   @  587   N16_439  $2.   
   @  589   N16_446  $2.   
/* @  591   N16_680  $100. */
   @  691   N16_545  $10.  
   @  701   N16_540  $10.  
   @  711   N16_3105 $10.  
   @  721   N16_3100 $10.  
   @  731   N16_550  $9.   
   @  740   N16_560  $2.   
   @  742   N16_570  $3.   
   @  745   N16_580  $8.   
   @  753   N16_581  $2.   
   @  755   N16_590  $8.   
   @  763   N16_591  $2.   
   @  765   N16_600  $8.   
   @  773   N16_601  $2.   
   @  775   N16_605  $1.   
   @  776   N16_610  $2.   
   @  778   N16_630  $2.   
/* @  780   N16_2400 $1.   */
   @  781   N16_668  $1.   
   @  782   N16_670  $2.   
   @  784   N16_672  $1.   
   @  785   N16_674  $1.   
   @  786   N16_676  $2.   
/* @  788   N16_2450 $1.   */
   @  789   N16_690  $1.   
   @  790   N16_700  $2.   
   @  792   N16_710  $2.   
   @  794   N16_720  $2.   
   @  796   N16_730  $1.   
   @  797   N16_740  $2.   
   @  799   N16_3280 $1.   
   @  800   N16_746  $2.   
   @  802   N16_747  $1.   
   @  803   N16_748  $1.   
/* @  804   N16_750  $30. */
   @  834   N16_930  $2.
   @  836   N16_990  $2.
   @  838   N16_1112 $1.
   @  839   N16_1113 $1.
   @  840   N16_1114 $1.
   @  841   N16_1115 $1.
   @  842   N16_1116 $1.
   @  843   N16_1117 $1.
   @  844   N16_752  $3.
   @  847   N16_754  $3.
   @  850   N16_756  $3.
   @  853   N16_3605 $5.
   @  858   N16_3610 $5.
   @  863   N16_3614 $5.
   @  868   N16_3616 $5.
   @  873   N16_3618 $5.
   @  878   N16_3620 $5.
   @  883   N16_3622 $1.
   @  884   N16_3624 $1.
   @  885   N16_3626 $1.
   @  886   N16_772  $3.
   @  889   N16_774  $3.
   @  892   N16_776  $2.
   @  894   N16_762  $1.
   @  895   N16_764  $1.
   @  896   N16_3650 $4.
   @  900   N16_3655 $4.
   @  904   N16_759  $1.   
   @  905   N16_760  $1.   
   @  906   N16_779  $12.  
   @  906   N16_780  $3.   
   @  909   N16_790  $2.   
   @  911   N16_800  $2.   
   @  913   N16_810  $1.   
   @  914   N16_820  $2.   
   @  916   N16_830  $2.   
   @  918   N16_840  $13.  
   @  931   N16_850  $2.   
   @  933   N16_860  $4.   
   @  937   N16_870  $1.   
   @  938   N16_1060 $2.   
   @  940   N16_880  $4.   
   @  944   N16_890  $4.   
   @  948   N16_900  $4.   
   @  952   N16_910  $4.   
   @  956   N16_920  $1.   
/* @  957   N16_2162 $1. */  
   @  958   N16_940  $4.   
   @  962   N16_950  $4.   
   @  966   N16_960  $4.   
   @  970   N16_970  $4.   
   @  974   N16_980  $1.   
/* @  975   N16_2163 $1. */
   @  976   N16_1120 $2.   
   @  978   N16_1130 $2.   
   @  980   N16_1140 $1.   
   @  981   N16_1150 $1.   
   @  982   N16_1160 $1.   
   @  983   N16_1170 $1.   
   @  984   N16_1182 $1.   
   @  985   N16_2800 $3.   
   @  988   N16_2810 $3.   
   @  991   N16_2820 $1.   
   @  992   N16_2830 $3.   
   @  995   N16_2840 $1.   
   @  996   N16_2850 $2.   
   @  998   N16_2860 $1.   
   @  999   N16_2851 $1.   
   @  1000  N16_2852 $1.   
   @  1001  N16_2853 $1.   
   @  1002  N16_2854 $1.   
   @  1003  N16_2880 $3.   
   @  1006  N16_2890 $3.   
   @  1009  N16_2900 $3.   
   @  1012  N16_2910 $3.   
   @  1015  N16_2920 $3.   
   @  1018  N16_2930 $3.   
   @  1021  N16_2861 $3.   
   @  1024  N16_2862 $3.   
   @  1027  N16_2863 $3.   
   @  1030  N16_2864 $3.   
   @  1033  N16_2865 $3.   
   @  1036  N16_2866 $3.   
   @  1039  N16_2867 $3.   
   @  1042  N16_2868 $3.   
   @  1045  N16_2869 $3.   
   @  1048  N16_2870 $3.   
   @  1051  N16_2871 $3.   
   @  1054  N16_2872 $3.   
   @  1057  N16_2873 $3.   
   @  1060  N16_2874 $3.   
   @  1063  N16_2875 $3.   
   @  1066  N16_2876 $3.   
   @  1069  N16_2877 $3.   
   @  1072  N16_2878 $3.   
   @  1075  N16_2879 $3.   
   @  1078  N16_2730 $3.   
   @  1081  N16_2735 $3.   
   @  1084  N16_2740 $1.   
   @  1085  N16_2750 $3.   
   @  1088  N16_2755 $1.   
   @  1089  N16_2760 $2.   
   @  1091  N16_2765 $1.   
   @  1092  N16_2770 $3.   
   @  1095  N16_2775 $3.   
   @  1098  N16_2780 $3.   
   @  1101  N16_2785 $2.   
   @  1103  N16_2940 $2.   
   @  1105  N16_2950 $1.   
   @  1106  N16_2960 $2.   
   @  1108  N16_2970 $1.   
   @  1109  N16_2980 $2.   
   @  1111  N16_2990 $1.   
   @  1112  N16_3000 $2.   
   @  1114  N16_3400 $3.   
   @  1117  N16_3402 $1.   
   @  1118  N16_3410 $3.   
   @  1121  N16_3412 $1.   
   @  1122  N16_3420 $3.   
   @  1125  N16_3422 $1.   
   @  1126  N16_3430 $3.   
   @  1129  N16_3440 $3.   
   @  1132  N16_3442 $1.   
   @  1133  N16_3450 $3.   
   @  1136  N16_3452 $1.   
   @  1137  N16_3460 $3.   
   @  1140  N16_3462 $1.   
   @  1141  N16_3470 $3.   
   @  1144  N16_3480 $3.   
   @  1147  N16_3482 $3.   
   @  1150  N16_3490 $2.   
   @  1152  N16_3492 $3.   
   @  1155  N16_3010 $1.   
   @  1156  N16_3020 $1.   
   @  1157  N16_3600 $1.   
   @  1158  N16_3030 $1.   
   @  1159  N16_3040 $1.   
   @  1160  N16_3050 $1.   
   @  1161  N16_2937 $6.   
   @  1167  N16_2935 $6.   
   @  1173  N16_2936 $6.   
   @  1179  N16_3700 $1.   
   @  1180  N16_3702 $1.   
   @  1181  N16_3704 $1.   
   @  1182  N16_3706 $1.   
   @  1183  N16_3708 $1.   
   @  1184  N16_3710 $1.   
   @  1185  N16_3165 $1.   
   @  1186  N16_3110 $5.   
   @  1191  N16_3120 $5.   
   @  1196  N16_3130 $5.   
   @  1201  N16_3140 $5.   
   @  1206  N16_3150 $5.   
   @  1211  N16_3160 $5.   
   @  1216  N16_3161 $5.   
   @  1221  N16_3162 $5.   
   @  1226  N16_3163 $5.   
   @  1231  N16_3164 $5.   
   @  1236  N16_3780 $7.   
   @  1243  N16_3782 $7.   
   @  1250  N16_3784 $7.   
   @  1257  N16_3786 $7.   
   @  1264  N16_3788 $7.   
   @  1271  N16_3790 $7.   
   @  1278  N16_3792 $7.   
   @  1285  N16_3794 $7.   
   @  1292  N16_3796 $7.   
   @  1299  N16_3798 $7.   
               
/* NPCR-specific fields */    
/* @  1306  N16_3720 $75.  */
   @  1306  N16_9980 $1.   
   @  1307  N16_9981 $8.   
   @  1315  N16_9960 $2.   
   @  1317  N16_9961 $3.   
   @  1320  N16_9965 $1.   
   @  1321  N16_9966 $1.   
   @  1322  N16_9967 $1.   
   @  1323  N16_9968 $1.   
   @  1324  N16_9970 $1.
   @  1325  N16_9969 $1.   
               
/* NPCR CER and PCOR fields */               
   @  1326  N16_8003 $1.   
   @  1327  N16_8004 $1.   
   @  1328  N16_8006 $1.   
   @  1329  N16_8007 $1.   
   @  1330  N16_8009 $1.   
   @  1331  N16_8010 $1.   
   @  1332  N16_8012 $2.   
   @  1334  N16_8013 $1.   
   @  1335  N16_8014 $1.   
   @  1336  N16_8016 $1.   
   @  1337  N16_8017 $1.   
   @  1338  N16_8019 $1.   
   @  1339  N16_8022 $2.   
   @  1341  N16_8023 $2.   
   @  1343  N16_8024 $2.   
   @  1345  N16_8025 $2.   
   @  1347  N16_8026 $1.   
   @  1348  N16_8001 $1. 

/* NPCR-SPECIFIC FIELDS FOR c AND p MODIFIERS */ 
   @  1349  N16_12000 $2.  
   @  1351  N16_12001 $2. 
   @  1353  N16_12002 $2. 
   @  1355  N16_12003 $2.  
   @  1357  N16_12004 $2. 
   @  1359  N16_12005 $2.  

/* NPCR-SPECIFIC FIELD FOR EARLY CASE CAPTURE/CHILDHOOD CANCER */
   @  1361  N16_12010 $1.
               
/* @  1381  N16_1180 $55.  */
   @  1436  N16_1260 $8.   
   @  1444  N16_1261 $2.   
   @  1446  N16_1270 $8.   
   @  1454  N16_1271 $2.   
   @  1456  N16_1200 $8.   
   @  1464  N16_1201 $2.   
   @  1466  N16_3170 $8.   
   @  1474  N16_3171 $2.   
   @  1476  N16_3180 $8.   
   @  1484  N16_3181 $2.   
   @  1486  N16_1210 $8.   
   @  1494  N16_1211 $2.   
   @  1496  N16_3220 $8.   
   @  1504  N16_3221 $2.   
   @  1506  N16_3230 $8.   
   @  1514  N16_3231 $2.   
   @  1516  N16_1220 $8.   
   @  1524  N16_1221 $2.   
   @  1526  N16_1230 $8.   
   @  1534  N16_1231 $2.   
   @  1536  N16_1240 $8.   
   @  1544  N16_1241 $2.   
   @  1546  N16_1250 $8.   
   @  1554  N16_1251 $2.   
   @  1556  N16_1280 $8.   
   @  1564  N16_1281 $2.   
   @  1566  N16_1285 $1.   
   @  1567  N16_1290 $2.   
   @  1569  N16_1292 $1.   
   @  1570  N16_1294 $1.   
   @  1571  N16_1296 $2.   
   @  1573  N16_1310 $1.   
   @  1574  N16_1320 $1.   
   @  1575  N16_1330 $1.   
   @  1576  N16_1340 $1.   
   @  1577  N16_1350 $2.   
   @  1579  N16_3270 $1.   
   @  1580  N16_1360 $1.   
   @  1581  N16_1370 $1.   
   @  1582  N16_1380 $1.   
   @  1583  N16_3250 $2.   
   @  1585  N16_1390 $2.   
   @  1587  N16_1400 $2.   
   @  1589  N16_1410 $2.   
   @  1591  N16_1420 $1.   
   @  1592  N16_1430 $1.   
   @  1593  N16_1460 $2.   
/* @  1595  N16_2161 $1.   */
   @  1596  N16_1510 $5.   
   @  1601  N16_1520 $3.   
   @  1604  N16_1540 $2.   
   @  1606  N16_1550 $1.   
   @  1607  N16_1570 $2.   
   @  1609  N16_3200 $2.   
   @  1611  N16_3210 $5.   
   @  1616  N16_1639 $1.   
   @  1617  N16_1640 $2.   
   @  1619  N16_3190 $1.   
   @  1620  N16_1646 $2.   
   @  1622  N16_1647 $1.   
   @  1623  N16_1648 $1.   
/* @  1624  N16_1190 $100. */
   @  1724  N16_1660 $8.   
   @  1732  N16_1661 $2.   
   @  1734  N16_1670 $11.  
   @  1734  N16_1671 $2.   
   @  1736  N16_1677 $1.   
   @  1737  N16_1678 $1.   
   @  1738  N16_1679 $2.   
   @  1740  N16_1672 $1.   
   @  1741  N16_1673 $1.   
   @  1742  N16_1674 $1.   
   @  1743  N16_1675 $1.   
   @  1744  N16_1676 $1.   
   @  1745  N16_1680 $8.   
   @  1753  N16_1681 $2.   
   @  1755  N16_1690 $11.  
   @  1755  N16_1691 $2.   
   @  1757  N16_1697 $1.   
   @  1758  N16_1698 $1.   
   @  1759  N16_1699 $2.   
   @  1761  N16_1692 $1.   
   @  1762  N16_1693 $1.   
   @  1763  N16_1694 $1.   
   @  1764  N16_1695 $1.   
   @  1765  N16_1696 $1.   
   @  1766  N16_1700 $8.   
   @  1774  N16_1701 $2.   
   @  1776  N16_1710 $11.  
   @  1776  N16_1711 $2.   
   @  1778  N16_1717 $1.   
   @  1779  N16_1718 $1.   
   @  1780  N16_1719 $2.   
   @  1782  N16_1712 $1.   
   @  1783  N16_1713 $1.   
   @  1784  N16_1714 $1.   
   @  1785  N16_1715 $1.   
   @  1786  N16_1716 $1.   
   @  1787  N16_1741 $1.   
/* @  1788  N16_1300 $100. */
   @  1888  N16_1981 $1.   
   @  1889  N16_1982 $1.   
   @  1890  N16_1983 $1.   
   @  1891  N16_1985 $1.   
   @  1892  N16_1986 $1.   
   @  1893  N16_1987 $1.   
   @  1894  N16_1988 $1.   
   @  1895  N16_1989 $1.   
   @  1896  N16_1990 $1.   
   @  1897  N16_2000 $1.   
   @  1898  N16_2010 $1.   
   @  1899  N16_2020 $1.   
   @  1900  N16_2030 $1.   
   @  1901  N16_2040 $1.   
   @  1902  N16_2050 $1.   
   @  1903  N16_2060 $1.   
   @  1904  N16_2070 $1.   
   @  1905  N16_2071 $1.   
   @  1906  N16_2072 $1.   
   @  1907  N16_2073 $1.   
   @  1908  N16_2074 $1.   
   @  1909  N16_1960 $4.   
   @  1913  N16_1970 $6.   
   @  1913  N16_1971 $4.   
   @  1917  N16_1972 $1.   
   @  1918  N16_1973 $1.   
   @  1919  N16_1980 $1.   
   @  1920  N16_2081 $10.  
   @  1930  N16_2120 $1.   
   @  1931  N16_2130 $1.   
   @  1932  N16_2140 $2.   
   @  1934  N16_2150 $2.   
   @  1936  N16_2170 $10.  
   @  1946  N16_2180 $1.   
   @  1947  N16_2190 $2.   
   @  1949  N16_2200 $2.   
   @  1951  N16_2085 $8.   
   @  1959  N16_2090 $8.   
   @  1967  N16_2092 $8.   
   @  1975  N16_2100 $8.   
   @  1983  N16_2110 $8.   
   @  1991  N16_2111 $8.   
   @  1999  N16_2112 $8.   
   @  2007  N16_2113 $8.   
   @  2015  N16_2116 $1.   
   @  2016  N16_3750 $1.   
   @  2017  N16_3751 $1.   
   @  2018  N16_3752 $1.   
   @  2019  N16_3753 $1.   
   @  2020  N16_3754 $1.   
   @  2021  N16_3755 $1.   
   @  2022  N16_3756 $1.   
   @  2023  N16_3757 $1.   
   @  2024  N16_3758 $1.   
   @  2025  N16_3759 $1.   
   @  2026  N16_3760 $1.   
   @  2027  N16_3761 $1.   
   @  2028  N16_3762 $1.   
   @  2029  N16_3763 $1.   
   @  2030  N16_3764 $1.   
   @  2031  N16_3765 $1.   
   @  2032  N16_3766 $1.   
   @  2033  N16_3767 $1.   
   @  2034  N16_3768 $1.   
   @  2035  N16_3769 $1.   
/* @  2036  N16_1650 $80.  */
   @  2116  N16_1750 $8.   
   @  2124  N16_1751 $2.   
   @  2126  N16_1760 $1.   
   @  2127  N16_1770 $1.   
   @  2128  N16_1780 $1.   
   @  2129  N16_1790 $1.   
   @  2130  N16_1800 $1.   
   @  2131  N16_1810 $50.  
   @  2181  N16_1820 $2.   
   @  2183  N16_1830 $9.   
   @  2192  N16_1840 $3.   
/* @  2195  N16_2700 $1.   */
   @  2196  N16_1860 $8.   
   @  2204  N16_1861 $2.   
   @  2206  N16_1880 $2.   
   @  2208  N16_1842 $50.  
   @  2258  N16_1844 $2.   
   @  2260  N16_1846 $9.   
   @  2269  N16_1910 $4.   
   @  2273  N16_1920 $1.   
   @  2274  N16_1930 $1.   
   @  2275  N16_1940 $3.   
   @  2278  N16_1791 $2.   
   @  2280  N16_1755 $8.   
   @  2288  N16_1756 $2.   
   @  2290  N16_1850 $2.   
   @  2292  N16_1782 $8.   
   @  2300  N16_1783 $1.   
   @  2301  N16_1784 $4.   
   @  2305  N16_1785 $8.   
   @  2313  N16_1786 $1.   
   @  2314  N16_1787 $4.   
   @  2318  N16_1788 $8.   
/* @  2326  N16_1740 $14.  */
/* @  2340  N16_2220 $1000.  */
               
/* Confidential record */              
   @  3340  N16_2230 $40.  
   @  3380  N16_2240 $40.  
   @  3420  N16_2250 $40.  
   @  3460  N16_2260 $3.   
   @  3463  N16_2270 $3.   
   @  3466  N16_2280 $40.  
   @  3506  N16_2390 $40.  
   @  3546  N16_2290 $60.  
   @  3606  N16_2300 $11.  
   @  3617  N16_2310 $2.   
   @  3619  N16_2320 $9.   
   @  3628  N16_2330 $60.  
   @  3688  N16_2335 $60.  
   @  3748  N16_2350 $60.  
   @  3808  N16_2355 $60.  
   @  3868  N16_2360 $10.  
   @  3878  N16_2380 $6.   
   @  3884  N16_2394 $60.  
   @  3944  N16_2392 $60.  
   @  4004  N16_2393 $60.  
   @  4064  N16_2352 $10.  
   @  4074  N16_2354 $11.  
/* @  4085  N16_1835 $200. */
   @  4285  N16_2445 $10.  
   @  4295  N16_2440 $10.  
   @  4305  N16_2415 $10.  
   @  4315  N16_2410 $10.  
   @  4325  N16_2425 $10.  
   @  4335  N16_2420 $10.  
/* @  4345  N16_1900 $50.  */
   @  4395  N16_2465 $10.  
   @  4405  N16_2460 $8.   
   @  4413  N16_2475 $10.  
   @  4423  N16_2470 $8.   
   @  4431  N16_2485 $10.  
   @  4441  N16_2480 $8.   
   @  4449  N16_2495 $10.  
   @  4459  N16_2490 $8.   
   @  4467  N16_2505 $10.  
   @  4477  N16_2500 $8.   
   @  4535  N16_7010 $25.  
   @  4560  N16_7090 $20.  
   @  4580  N16_7320 $14.  
   @  4594  N16_7480 $2.   
   @  4596  N16_7190 $25.  
   @  4621  N16_7100 $20.  
   @  4641  N16_7011 $25.  
   @  4666  N16_7091 $20.  
   @  4686  N16_7321 $14.  
   @  4700  N16_7481 $2.   
   @  4702  N16_7191 $25.  
   @  4727  N16_7101 $20.  
   @  4747  N16_7012 $25.  
   @  4772  N16_7092 $20.  
   @  4792  N16_7322 $14.  
   @  4806  N16_7482 $2.   
   @  4808  N16_7192 $25.  
   @  4833  N16_7102 $20.  
   @  4853  N16_7013 $25.  
   @  4878  N16_7093 $20.  
   @  4898  N16_7323 $14.  
   @  4912  N16_7483 $2.   
   @  4914  N16_7193 $25.  
   @  4939  N16_7103 $20.  
   @  4959  N16_7014 $25.  
   @  4984  N16_7094 $20.  
   @  5004  N16_7324 $14.  
   @  5018  N16_7484 $2.   
   @  5020  N16_7194 $25.  
   @  5045  N16_7104 $20.  
/* @  5065  N16_2080 $500. */
               
/* NPCR CER and PCOR fields */               
   @  5065  N16_8000 $8.   
   @  5073  N16_8002 $8.   
   @  5081  N16_8005 $8.   
   @  5089  N16_8008 $8.   
   @  5097  N16_8011 $8.   
   @  5105  N16_8015 $8.   
   @  5113  N16_8018 $8.   
   @  5121  N16_8020 $8.   
   @  5129  N16_8021 $2.   
   @  5133  N16_9751 $6.   
   @  5139  N16_9761 $2.   
   @  5141  N16_9771 $6.   
   @  5147  N16_9781 $2.   
   @  5149  N16_9791 $2.   
   @  5151  N16_9801 $6.   
   @  5157  N16_9811 $2.   
   @  5159  N16_9821 $8.   
   @  5167  N16_9831 $2.   
   @  5169  N16_9841 $8.   
   @  5177  N16_9851 $2.   
   @  5179  N16_9752 $6.   
   @  5185  N16_9762 $2.   
   @  5187  N16_9772 $6.   
   @  5193  N16_9782 $2.   
   @  5195  N16_9792 $2.   
   @  5197  N16_9802 $6.   
   @  5203  N16_9812 $2.   
   @  5205  N16_9822 $8.   
   @  5213  N16_9832 $2.   
   @  5215  N16_9842 $8.   
   @  5223  N16_9852 $2.   
   @  5225  N16_9900 $3.   
   @  5228  N16_9901 $8.   
   @  5236  N16_9902 $2.   
   @  5238  N16_9903 $3.   
   @  5241  N16_9904 $8.   
   @  5249  N16_9905 $2.   
   @  5251  N16_9906 $3.   
   @  5254  N16_9907 $8.   
   @  5262  N16_9908 $2.   
   @  5264  N16_9909 $3.   
   @  5267  N16_9910 $8.   
   @  5275  N16_9911 $2.   
   @  5277  N16_9753 $6.   
   @  5283  N16_9763 $2.   
   @  5285  N16_9773 $6.   
   @  5291  N16_9783 $2.   
   @  5293  N16_9793 $2.   
   @  5295  N16_9803 $6.   
   @  5301  N16_9813 $2.   
   @  5303  N16_9823 $8.   
   @  5311  N16_9833 $2.   
   @  5313  N16_9843 $8.   
   @  5321  N16_9853 $2.   
   @  5323  N16_9754 $6.   
   @  5329  N16_9764 $2.   
   @  5331  N16_9774 $6.   
   @  5337  N16_9784 $2.   
   @  5339  N16_9794 $2.   
   @  5341  N16_9804 $6.   
   @  5347  N16_9814 $2.   
   @  5349  N16_9824 $8.   
   @  5357  N16_9834 $2.   
   @  5359  N16_9844 $8.   
   @  5367  N16_9854 $2.   
   @  5369  N16_9755 $6.   
   @  5375  N16_9765 $2.   
   @  5377  N16_9775 $6.   
   @  5383  N16_9785 $2.   
   @  5385  N16_9795 $2.   
   @  5387  N16_9805 $6.   
   @  5393  N16_9815 $2.   
   @  5395  N16_9825 $8.   
   @  5403  N16_9835 $2.   
   @  5405  N16_9845 $8.   
   @  5413  N16_9855 $2.   
   @  5415  N16_9756 $6.   
   @  5421  N16_9766 $2.   
   @  5423  N16_9776 $6.   
   @  5429  N16_9786 $2.   
   @  5431  N16_9796 $2.   
   @  5433  N16_9806 $6.   
   @  5439  N16_9816 $2.   
   @  5441  N16_9826 $8.   
   @  5449  N16_9836 $2.   
   @  5451  N16_9846 $8.   
   @  5459  N16_9856 $2.   
   @  5461  N16_9859 $1.   
   @  5462  N16_9920 $1.   
   @  5463  N16_9921 $2.   
   @  5465  N16_9922 $2.   
   @  5467  N16_9923 $2.   
   @  5469  N16_9924 $2.   
   @  5471  N16_9925 $2.   
   @  5473  N16_9926 $1.   
   @  5474  N16_9927 $2.   
   @  5476  N16_9931 $6.   
   @  5482  N16_9932 $6.   
   @  5488  N16_9933 $6.   
   @  5494  N16_9934 $6.   
   @  5500  N16_9935 $6.   
   @  5506  N16_9936 $6.   
   @  5512  N16_9941 $6.   
   @  5518  N16_9942 $6.   
   @  5524  N16_9951 $6.   
   @  5530  N16_9952 $6.   
   @  5536  N16_9955 $2.   
   @  5538  N16_9861 $6.   
   @  5544  N16_9862 $6.   
   @  5550  N16_9871 $6.   
   @  5556  N16_9872 $6.   
   @  5562  N16_9880 $1.   
   @  5563  N16_9881 $1.   
   @  5564  N16_9882 $1.                  
               
/* Text record */ 
   @  5565  N16_2520 $1000.   
   @  6565  N16_2530 $1000.   
   @  7565  N16_2540 $1000.   
   @  8565  N16_2550 $1000.   
   @  9565  N16_2560 $1000.   
   @  10565 N16_2570 $1000.   
   @  11565 N16_2580 $100. 
   @  11665 N16_2590 $100. 
   @  11765 N16_2600 $1000.   
   @  12765 N16_2610 $1000.   
   @  13765 N16_2620 $1000.   
   @  14765 N16_2630 $1000.   
   @  15765 N16_2640 $1000.   
   @  16765 N16_2650 $1000.   
   @  17765 N16_2660 $1000.   
   @  18765 N16_2670 $1000.   
   @  19765 N16_2680 $1000.   
   @  20765 N16_2690 $60. 
/* @  20825 N16_2210 2000. */
;
run;

