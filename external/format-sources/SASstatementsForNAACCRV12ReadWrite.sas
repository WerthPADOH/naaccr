/*----------------------------------------------------*/


/* SAS PROGRAM TO READ AND WRITE NAACCR V12.1 RECORD LAYOUTS */

*** USER SHOULD CHANGE FILE REFERENCES FOR INPUT AND OUTPUT FLAT ASCII FILES ***;

*** THE OUTV12 FILEREF MAY BE USED AS INPUT FOR SEERSTAT WHEN SEERSTAT SUPPORTS
*** THE V12 NAACCR LAYOUT VIA A .DD FILE. ***;

*** THIS PROGRAM HAS BEEN TESTED BY COMPARING THE INPUT AND OUTPUT ASCII FILES
*** FOR THE CONFIDENTIAL LAYOUT 


 filename inv12     'V:\data\CANCER\NAACCR\DataStandardsAndDictionary\id2008.n12';
 filename outv12    'V:\data\CANCER\NAACCR\DataStandardsAndDictionary\id2008.txd';

*libname c v8 'c:\data\cancer\seerstat';

data V12 /*V12conv*/ /*test*/;  
*  infile in       lrecl =  3339 pad missover; /* INCIDENCE */
   infile inv12    lrecl =  5564 pad missover; /* CONFIDENTIAL */
*  infile in       lrecl = 22824 pad missover; /* TEXT */

input N12_10   $  1-1         @; label N12_10   ='Record Type';
input N12_30   $  2-2         @; label N12_30   ='Registry Type';
input N12_35   $  3-3         @; label N12_35   ='FIN Coding System';
input N12_37   $  4-16        @; label N12_37   ='Reserved 00';
input N12_50   $  17-19       @; label N12_50   ='NAACCR Record Version';
input N12_45   $  20-29       @; label N12_45   ='NPI--Registry ID';
input N12_40   $  30-39       @; label N12_40   ='Registry ID';
input N12_60   $  40-41       @; label N12_60   ='Tumor Record Number';
input N12_20   $  42-49       @; label N12_20   ='Patient ID Number';
input N12_21   $  50-57       @; label N12_21   ='Patient System ID-Hosp';
input N12_370  $  58-94       @; label N12_370  ='Reserved 01';
input N12_70   $  95-144      @; label N12_70   ='Addr at DX--City';
input N12_80   $  145-146     @; label N12_80   ='Addr at DX--State';
input N12_100  $  147-155     @; label N12_100  ='Addr at DX--Postal Code';
input N12_90   $  156-158     @; label N12_90   ='County at DX';
input N12_110  $  159-164     @; label N12_110  ='Census Tract 1970/80/90';
input N12_368  $  165-165     @; label N12_368  ='CensusBlockGroup 70/80/90';
input N12_120  $  166-166     @; label N12_120  ='Census Cod Sys 1970/80/90';
input N12_364  $  167-167     @; label N12_364  ='Census Tr Cert 1970/80/90';
input N12_130  $  168-173     @; label N12_130  ='Census Tract 2000';
input N12_362  $  174-174     @; label N12_362  ='Census Block Group 2000';
input N12_365  $  175-175     @; label N12_365  ='Census Tr Certainty 2000';
input N12_150  $  176-176     @; label N12_150  ='Marital Status at DX';
input N12_160  $  177-178     @; label N12_160  ='Race 1';
input N12_161  $  179-180     @; label N12_161  ='Race 2';
input N12_162  $  181-182     @; label N12_162  ='Race 3';
input N12_163  $  183-184     @; label N12_163  ='Race 4';
input N12_164  $  185-186     @; label N12_164  ='Race 5';
input N12_170  $  187-187     @; label N12_170  ='Race Coding Sys--Current';
input N12_180  $  188-188     @; label N12_180  ='Race Coding Sys--Original';
input N12_190  $  189-189     @; label N12_190  ='Spanish/Hispanic Origin';
input N12_200  $  190-190     @; label N12_200  ='Computed Ethnicity';
input N12_210  $  191-191     @; label N12_210  ='Computed Ethnicity Source';
input N12_220  $  192-192     @; label N12_220  ='Sex';
input N12_230  $  193-195     @; label N12_230  ='Age at Diagnosis';
input N12_240  $  196-203     @; label N12_240  ='Date of Birth';
input N12_241  $  204-205     @; label N12_241  ='Date of Birth Flag';
input N12_250  $  206-208     @; label N12_250  ='Birthplace';
input N12_270  $  209-211     @; label N12_270  ='Occupation Code--Census';
input N12_280  $  212-214     @; label N12_280  ='Industry Code--Census';
input N12_290  $  215-215     @; label N12_290  ='Occupation Source';
input N12_300  $  216-216     @; label N12_300  ='Industry Source';
input N12_310  $  217-316     @; label N12_310  ='Text--Usual Occupation';
input N12_320  $  317-416     @; label N12_320  ='Text--Usual Industry';
input N12_330  $  417-417     @; label N12_330  ='Occup/Ind Coding System';
input N12_191  $  418-418     @; label N12_191  ='NHIA Derived Hisp Origin';
input N12_193  $  419-420     @; label N12_193  ='Race--NAPIIA(derived API)';
input N12_192  $  421-421     @; label N12_192  ='IHS Link';
input N12_366  $  422-423     @; label N12_366  ='GIS Coordinate Quality';
input N12_3300 $  424-425     @; label N12_3300 ='RuralUrban Continuum 1993';
input N12_3310 $  426-427     @; label N12_3310 ='RuralUrban Continuum 2003';
input N12_135  $  428-433     @; label N12_135  ='Census Tract 2010';
input N12_363  $  434-434     @; label N12_363  ='Census Block Group 2010';
input N12_367  $  435-435     @; label N12_367  ='Census Tr Certainty 2010';
input N12_530  $  436-527     @; label N12_530  ='Reserved 02';
input N12_380  $  528-529     @; label N12_380  ='Sequence Number--Central';
input N12_390  $  530-537     @; label N12_390  ='Date of Diagnosis';
input N12_391  $  538-539     @; label N12_391  ='Date of Diagnosis Flag';
input N12_400  $  540-543     @; label N12_400  ='Primary Site';
input N12_410  $  544-544     @; label N12_410  ='Laterality';
input N12_419  $  545-549     @; label N12_419  ='Morph--Type&Behav ICD-O-2';
input N12_420  $  545-548     @; label N12_420  ='Histology (92-00) ICD-O-2';
input N12_430  $  549-549     @; label N12_430  ='Behavior (92-00) ICD-O-2';
input N12_521  $  550-554     @; label N12_521  ='Morph--Type&Behav ICD-O-3';
input N12_522  $  550-553     @; label N12_522  ='Histologic Type ICD-O-3';
input N12_523  $  554-554     @; label N12_523  ='Behavior Code ICD-O-3';
input N12_440  $  555-555     @; label N12_440  ='Grade';
input N12_441  $  556-556     @; label N12_441  ='Grade Path Value';
input N12_449  $  557-557     @; label N12_449  ='Grade Path System';
input N12_450  $  558-558     @; label N12_450  ='Site Coding Sys--Current';
input N12_460  $  559-559     @; label N12_460  ='Site Coding Sys--Original';
input N12_470  $  560-560     @; label N12_470  ='Morph Coding Sys--Current';
input N12_480  $  561-561     @; label N12_480  ='Morph Coding Sys--Originl';
input N12_490  $  562-562     @; label N12_490  ='Diagnostic Confirmation';
input N12_500  $  563-563     @; label N12_500  ='Type of Reporting Source';
input N12_501  $  564-565     @; label N12_501  ='Casefinding Source';
input N12_442  $  566-566     @; label N12_442  ='Ambiguous Terminology DX';
input N12_443  $  567-574     @; label N12_443  ='Date of Conclusive DX';
input N12_448  $  575-576     @; label N12_448  ='Date Conclusive DX Flag';
input N12_444  $  577-578     @; label N12_444  ='Mult Tum Rpt as One Prim';
input N12_445  $  579-586     @; label N12_445  ='Date of Multiple Tumors';
input N12_439  $  587-588     @; label N12_439  ='Date of Mult Tumors Flag';
input N12_446  $  589-590     @; label N12_446  ='Multiplicity Counter';
input N12_680  $  591-690     @; label N12_680  ='Reserved 03';
input N12_545  $  691-700     @; label N12_545  ='NPI--Reporting Facility';
input N12_540  $  701-710     @; label N12_540  ='Reporting Facility';
input N12_3105 $  711-720     @; label N12_3105 ='NPI--Archive FIN';
input N12_3100 $  721-730     @; label N12_3100 ='Archive FIN';
input N12_550  $  731-739     @; label N12_550  ='Accession Number--Hosp';
input N12_560  $  740-741     @; label N12_560  ='Sequence Number--Hospital';
input N12_570  $  742-744     @; label N12_570  ='Abstracted By';
input N12_580  $  745-752     @; label N12_580  ='Date of 1st Contact';
input N12_581  $  753-754     @; label N12_581  ='Date of 1st Contact Flag';
input N12_590  $  755-762     @; label N12_590  ='Date of Inpatient Adm';
input N12_591  $  763-764     @; label N12_591  ='Date of Inpt Adm Flag';
input N12_600  $  765-772     @; label N12_600  ='Date of Inpatient Disch';
input N12_601  $  773-774     @; label N12_601  ='Date of Inpt Disch Flag';
input N12_605  $  775-775     @; label N12_605  ='Inpatient Status';
input N12_610  $  776-777     @; label N12_610  ='Class of Case';
input N12_630  $  778-779     @; label N12_630  ='Primary Payer at DX';
input N12_2400 $  780-780     @; label N12_2400 ='Reserved 16';
input N12_668  $  781-781     @; label N12_668  ='RX Hosp--Surg App 2010';
input N12_670  $  782-783     @; label N12_670  ='RX Hosp--Surg Prim Site';
input N12_672  $  784-784     @; label N12_672  ='RX Hosp--Scope Reg LN Sur';
input N12_674  $  785-785     @; label N12_674  ='RX Hosp--Surg Oth Reg/Dis';
input N12_676  $  786-787     @; label N12_676  ='RX Hosp--Reg LN Removed';
input N12_2450 $  788-788     @; label N12_2450 ='Reserved 17';
input N12_690  $  789-789     @; label N12_690  ='RX Hosp--Radiation';
input N12_700  $  790-791     @; label N12_700  ='RX Hosp--Chemo';
input N12_710  $  792-793     @; label N12_710  ='RX Hosp--Hormone';
input N12_720  $  794-795     @; label N12_720  ='RX Hosp--BRM';
input N12_730  $  796-796     @; label N12_730  ='RX Hosp--Other';
input N12_740  $  797-798     @; label N12_740  ='RX Hosp--DX/Stg Proc';
input N12_3280 $  799-799     @; label N12_3280 ='RX Hosp--Palliative Proc';
input N12_746  $  800-801     @; label N12_746  ='RX Hosp--Surg Site 98-02';
input N12_747  $  802-802     @; label N12_747  ='RX Hosp--Scope Reg 98-02';
input N12_748  $  803-803     @; label N12_748  ='RX Hosp--Surg Oth 98-02';
input N12_750  $  804-903     @; label N12_750  ='Reserved 04';
input N12_759  $  904-904     @; label N12_759  ='SEER Summary Stage 2000';
input N12_760  $  905-905     @; label N12_760  ='SEER Summary Stage 1977';
input N12_779  $  906-917     @; label N12_779  ='Extent of Disease 10-Dig';
input N12_780  $  906-908     @; label N12_780  ='EOD--Tumor Size';
input N12_790  $  909-910     @; label N12_790  ='EOD--Extension';
input N12_800  $  911-912     @; label N12_800  ='EOD--Extension Prost Path';
input N12_810  $  913-913     @; label N12_810  ='EOD--Lymph Node Involv';
input N12_820  $  914-915     @; label N12_820  ='Regional Nodes Positive';
input N12_830  $  916-917     @; label N12_830  ='Regional Nodes Examined';
input N12_840  $  918-930     @; label N12_840  ='EOD--Old 13 Digit';
input N12_850  $  931-932     @; label N12_850  ='EOD--Old 2 Digit';
input N12_860  $  933-936     @; label N12_860  ='EOD--Old 4 Digit';
input N12_870  $  937-937     @; label N12_870  ='Coding System for EOD';
input N12_1060 $  938-939     @; label N12_1060 ='TNM Edition Number';
input N12_880  $  940-943     @; label N12_880  ='TNM Path T';
input N12_890  $  944-947     @; label N12_890  ='TNM Path N';
input N12_900  $  948-951     @; label N12_900  ='TNM Path M';
input N12_910  $  952-955     @; label N12_910  ='TNM Path Stage Group';
input N12_920  $  956-956     @; label N12_920  ='TNM Path Descriptor';
input N12_930  $  957-957     @; label N12_930  ='TNM Path Staged By';
input N12_940  $  958-961     @; label N12_940  ='TNM Clin T';
input N12_950  $  962-965     @; label N12_950  ='TNM Clin N';
input N12_960  $  966-969     @; label N12_960  ='TNM Clin M';
input N12_970  $  970-973     @; label N12_970  ='TNM Clin Stage Group';
input N12_980  $  974-974     @; label N12_980  ='TNM Clin Descriptor';
input N12_990  $  975-975     @; label N12_990  ='TNM Clin Staged By';
input N12_1120 $  976-977     @; label N12_1120 ='Pediatric Stage';
input N12_1130 $  978-979     @; label N12_1130 ='Pediatric Staging System';
input N12_1140 $  980-980     @; label N12_1140 ='Pediatric Staged By';
input N12_1150 $  981-981     @; label N12_1150 ='Tumor Marker 1';
input N12_1160 $  982-982     @; label N12_1160 ='Tumor Marker 2';
input N12_1170 $  983-983     @; label N12_1170 ='Tumor Marker 3';
input N12_1182 $  984-984     @; label N12_1182 ='Lymph-vascular Invasion';
input N12_2800 $  985-987     @; label N12_2800 ='CS Tumor Size';
input N12_2810 $  988-990     @; label N12_2810 ='CS Extension';
input N12_2820 $  991-991     @; label N12_2820 ='CS Tumor Size/Ext Eval';
input N12_2830 $  992-994     @; label N12_2830 ='CS Lymph Nodes';
input N12_2840 $  995-995     @; label N12_2840 ='CS Lymph Nodes Eval';
input N12_2850 $  996-997     @; label N12_2850 ='CS Mets at DX';
input N12_2860 $  998-998     @; label N12_2860 ='CS Mets Eval';
input N12_2851 $  999-999     @; label N12_2851 ='CS Mets at Dx-Bone';
input N12_2852 $  1000-1000   @; label N12_2852 ='CS Mets at Dx-Brain';
input N12_2853 $  1001-1001   @; label N12_2853 ='CS Mets at Dx-Liver';
input N12_2854 $  1002-1002   @; label N12_2854 ='CS Mets at Dx-Lung';
input N12_2880 $  1003-1005   @; label N12_2880 ='CS Site-Specific Factor 1';
input N12_2890 $  1006-1008   @; label N12_2890 ='CS Site-Specific Factor 2';
input N12_2900 $  1009-1011   @; label N12_2900 ='CS Site-Specific Factor 3';
input N12_2910 $  1012-1014   @; label N12_2910 ='CS Site-Specific Factor 4';
input N12_2920 $  1015-1017   @; label N12_2920 ='CS Site-Specific Factor 5';
input N12_2930 $  1018-1020   @; label N12_2930 ='CS Site-Specific Factor 6';
input N12_2861 $  1021-1023   @; label N12_2861 ='CS Site-Specific Factor 7';
input N12_2862 $  1024-1026   @; label N12_2862 ='CS Site-Specific Factor 8';
input N12_2863 $  1027-1029   @; label N12_2863 ='CS Site-Specific Factor 9';
input N12_2864 $  1030-1032   @; label N12_2864 ='CS Site-Specific Factor10';
input N12_2865 $  1033-1035   @; label N12_2865 ='CS Site-Specific Factor11';
input N12_2866 $  1036-1038   @; label N12_2866 ='CS Site-Specific Factor12';
input N12_2867 $  1039-1041   @; label N12_2867 ='CS Site-Specific Factor13';
input N12_2868 $  1042-1044   @; label N12_2868 ='CS Site-Specific Factor14';
input N12_2869 $  1045-1047   @; label N12_2869 ='CS Site-Specific Factor15';
input N12_2870 $  1048-1050   @; label N12_2870 ='CS Site-Specific Factor16';
input N12_2871 $  1051-1053   @; label N12_2871 ='CS Site-Specific Factor17';
input N12_2872 $  1054-1056   @; label N12_2872 ='CS Site-Specific Factor18';
input N12_2873 $  1057-1059   @; label N12_2873 ='CS Site-Specific Factor19';
input N12_2874 $  1060-1062   @; label N12_2874 ='CS Site-Specific Factor20';
input N12_2875 $  1063-1065   @; label N12_2875 ='CS Site-Specific Factor21';
input N12_2876 $  1066-1068   @; label N12_2876 ='CS Site-Specific Factor22';
input N12_2877 $  1069-1071   @; label N12_2877 ='CS Site-Specific Factor23';
input N12_2878 $  1072-1074   @; label N12_2878 ='CS Site-Specific Factor24';
input N12_2879 $  1075-1077   @; label N12_2879 ='CS Site-Specific Factor25';
input N12_2730 $  1078-1080   @; label N12_2730 ='CS PreRx Tumor Size';
input N12_2735 $  1081-1083   @; label N12_2735 ='CS PreRx Extension';
input N12_2740 $  1084-1084   @; label N12_2740 ='CS PreRx Tum Sz/Ext Eval';
input N12_2750 $  1085-1087   @; label N12_2750 ='CS PreRx Lymph Nodes';
input N12_2755 $  1088-1088   @; label N12_2755 ='CS PreRx Reg Nodes Eval';
input N12_2760 $  1089-1090   @; label N12_2760 ='CS PreRx Mets at DX';
input N12_2765 $  1091-1091   @; label N12_2765 ='CS PreRx Mets Eval';
input N12_2770 $  1092-1094   @; label N12_2770 ='CS PostRx Tumor Size';
input N12_2775 $  1095-1097   @; label N12_2775 ='CS PostRx Extension';
input N12_2780 $  1098-1100   @; label N12_2780 ='CS PostRx Lymph Nodes';
input N12_2785 $  1101-1102   @; label N12_2785 ='CS PostRx Mets at DX';
input N12_2940 $  1103-1104   @; label N12_2940 ='Derived AJCC-6 T';
input N12_2950 $  1105-1105   @; label N12_2950 ='Derived AJCC-6 T Descript';
input N12_2960 $  1106-1107   @; label N12_2960 ='Derived AJCC-6 N';
input N12_2970 $  1108-1108   @; label N12_2970 ='Derived AJCC-6 N Descript';
input N12_2980 $  1109-1110   @; label N12_2980 ='Derived AJCC-6 M';
input N12_2990 $  1111-1111   @; label N12_2990 ='Derived AJCC-6 M Descript';
input N12_3000 $  1112-1113   @; label N12_3000 ='Derived AJCC-6 Stage Grp';
input N12_3400 $  1114-1116   @; label N12_3400 ='Derived AJCC-7 T';
input N12_3402 $  1117-1117   @; label N12_3402 ='Derived AJCC-7 T Descript';
input N12_3410 $  1118-1120   @; label N12_3410 ='Derived AJCC-7 N';
input N12_3412 $  1121-1121   @; label N12_3412 ='Derived AJCC-7 N Descript';
input N12_3420 $  1122-1124   @; label N12_3420 ='Derived AJCC-7 M';
input N12_3422 $  1125-1125   @; label N12_3422 ='Derived AJCC-7 M Descript';
input N12_3430 $  1126-1128   @; label N12_3430 ='Derived AJCC-7 Stage Grp';
input N12_3440 $  1129-1131   @; label N12_3440 ='Derived PreRx-7 T';
input N12_3442 $  1132-1132   @; label N12_3442 ='Derived PreRx-7 T Descrip';
input N12_3450 $  1133-1135   @; label N12_3450 ='Derived PreRx-7 N';
input N12_3452 $  1136-1136   @; label N12_3452 ='Derived PreRx-7 N Descrip';
input N12_3460 $  1137-1139   @; label N12_3460 ='Derived PreRx-7 M';
input N12_3462 $  1140-1140   @; label N12_3462 ='Derived PreRx-7 M Descrip';
input N12_3470 $  1141-1143   @; label N12_3470 ='Derived PreRx-7 Stage Grp';
input N12_3480 $  1144-1146   @; label N12_3480 ='Derived PostRx-7 T';
input N12_3482 $  1147-1149   @; label N12_3482 ='Derived PostRx-7 N';
input N12_3490 $  1150-1151   @; label N12_3490 ='Derived PostRx-7 M';
input N12_3492 $  1152-1154   @; label N12_3492 ='Derived PostRx-7 Stge Grp';
input N12_3010 $  1155-1155   @; label N12_3010 ='Derived SS1977';
input N12_3020 $  1156-1156   @; label N12_3020 ='Derived SS2000';
input N12_3600 $  1157-1157   @; label N12_3600 ='Derived Neoadjuv Rx Flag';
input N12_3030 $  1158-1158   @; label N12_3030 ='Derived AJCC--Flag';
input N12_3040 $  1159-1159   @; label N12_3040 ='Derived SS1977--Flag';
input N12_3050 $  1160-1160   @; label N12_3050 ='Derived SS2000--Flag';
input N12_2937 $  1161-1166   @; label N12_2937 ='CS Version Input Current';
input N12_2935 $  1167-1172   @; label N12_2935 ='CS Version Input Original';
input N12_2936 $  1173-1178   @; label N12_2936 ='CS Version Derived';
input N12_3700 $  1179-1179   @; label N12_3700 ='SEER Site-Specific Fact 1';
input N12_3702 $  1180-1180   @; label N12_3702 ='SEER Site-Specific Fact 2';
input N12_3704 $  1181-1181   @; label N12_3704 ='SEER Site-Specific Fact 3';
input N12_3706 $  1182-1182   @; label N12_3706 ='SEER Site-Specific Fact 4';
input N12_3708 $  1183-1183   @; label N12_3708 ='SEER Site-Specific Fact 5';
input N12_3710 $  1184-1184   @; label N12_3710 ='SEER Site-Specific Fact 6';
input N12_3165 $  1185-1185   @; label N12_3165 ='ICD Revision Comorbid';
input N12_3110 $  1186-1190   @; label N12_3110 ='Comorbid/Complication 1';
input N12_3120 $  1191-1195   @; label N12_3120 ='Comorbid/Complication 2';
input N12_3130 $  1196-1200   @; label N12_3130 ='Comorbid/Complication 3';
input N12_3140 $  1201-1205   @; label N12_3140 ='Comorbid/Complication 4';
input N12_3150 $  1206-1210   @; label N12_3150 ='Comorbid/Complication 5';
input N12_3160 $  1211-1215   @; label N12_3160 ='Comorbid/Complication 6';
input N12_3161 $  1216-1220   @; label N12_3161 ='Comorbid/Complication 7';
input N12_3162 $  1221-1225   @; label N12_3162 ='Comorbid/Complication 8';
input N12_3163 $  1226-1230   @; label N12_3163 ='Comorbid/Complication 9';
input N12_3164 $  1231-1235   @; label N12_3164 ='Comorbid/Complication 10';
input N12_1180 $  1236-1435   @; label N12_1180 ='Reserved 05';
input N12_1260 $  1436-1443   @; label N12_1260 ='Date of Initial RX--SEER';
input N12_1261 $  1444-1445   @; label N12_1261 ='Date of Initial RX Flag';
input N12_1270 $  1446-1453   @; label N12_1270 ='Date of 1st Crs RX--CoC';
input N12_1271 $  1454-1455   @; label N12_1271 ='Date of 1st Crs Rx Flag';
input N12_1200 $  1456-1463   @; label N12_1200 ='RX Date--Surgery';
input N12_1201 $  1464-1465   @; label N12_1201 ='RX Date--Surgery Flag';
input N12_3170 $  1466-1473   @; label N12_3170 ='RX Date--Most Defin Surg';
input N12_3171 $  1474-1475   @; label N12_3171 ='RX Date Mst Defn Srg Flag';
input N12_3180 $  1476-1483   @; label N12_3180 ='RX Date--Surgical Disch';
input N12_3181 $  1484-1485   @; label N12_3181 ='RX Date Surg Disch Flag';
input N12_1210 $  1486-1493   @; label N12_1210 ='RX Date--Radiation';
input N12_1211 $  1494-1495   @; label N12_1211 ='RX Date--Radiation Flag';
input N12_3220 $  1496-1503   @; label N12_3220 ='RX Date--Radiation Ended';
input N12_3221 $  1504-1505   @; label N12_3221 ='RX Date Rad Ended Flag';
input N12_3230 $  1506-1513   @; label N12_3230 ='RX Date--Systemic';
input N12_3231 $  1514-1515   @; label N12_3231 ='RX Date Systemic Flag';
input N12_1220 $  1516-1523   @; label N12_1220 ='RX Date--Chemo';
input N12_1221 $  1524-1525   @; label N12_1221 ='RX Date--Chemo Flag';
input N12_1230 $  1526-1533   @; label N12_1230 ='RX Date--Hormone';
input N12_1231 $  1534-1535   @; label N12_1231 ='RX Date--Hormone Flag';
input N12_1240 $  1536-1543   @; label N12_1240 ='RX Date--BRM';
input N12_1241 $  1544-1545   @; label N12_1241 ='RX Date--BRM Flag';
input N12_1250 $  1546-1553   @; label N12_1250 ='RX Date--Other';
input N12_1251 $  1554-1555   @; label N12_1251 ='RX Date--Other Flag';
input N12_1280 $  1556-1563   @; label N12_1280 ='RX Date--DX/Stg Proc';
input N12_1281 $  1564-1565   @; label N12_1281 ='RX Date--Dx/Stg Proc Flag';
input N12_1285 $  1566-1566   @; label N12_1285 ='RX Summ--Treatment Status';
input N12_1290 $  1567-1568   @; label N12_1290 ='RX Summ--Surg Prim Site';
input N12_1292 $  1569-1569   @; label N12_1292 ='RX Summ--Scope Reg LN Sur';
input N12_1294 $  1570-1570   @; label N12_1294 ='RX Summ--Surg Oth Reg/Dis';
input N12_1296 $  1571-1572   @; label N12_1296 ='RX Summ--Reg LN Examined';
input N12_1310 $  1573-1573   @; label N12_1310 ='RX Summ--Surgical Approch';
input N12_1320 $  1574-1574   @; label N12_1320 ='RX Summ--Surgical Margins';
input N12_1330 $  1575-1575   @; label N12_1330 ='RX Summ--Reconstruct 1st';
input N12_1340 $  1576-1576   @; label N12_1340 ='Reason for No Surgery';
input N12_1350 $  1577-1578   @; label N12_1350 ='RX Summ--DX/Stg Proc';
input N12_3270 $  1579-1579   @; label N12_3270 ='RX Summ--Palliative Proc';
input N12_1360 $  1580-1580   @; label N12_1360 ='RX Summ--Radiation';
input N12_1370 $  1581-1581   @; label N12_1370 ='RX Summ--Rad to CNS';
input N12_1380 $  1582-1582   @; label N12_1380 ='RX Summ--Surg/Rad Seq';
input N12_3250 $  1583-1584   @; label N12_3250 ='RX Summ--Transplnt/Endocr';
input N12_1390 $  1585-1586   @; label N12_1390 ='RX Summ--Chemo';
input N12_1400 $  1587-1588   @; label N12_1400 ='RX Summ--Hormone';
input N12_1410 $  1589-1590   @; label N12_1410 ='RX Summ--BRM';
input N12_1420 $  1591-1591   @; label N12_1420 ='RX Summ--Other';
input N12_1430 $  1592-1592   @; label N12_1430 ='Reason for No Radiation';
input N12_1460 $  1593-1594   @; label N12_1460 ='RX Coding System--Current';
input N12_1500 $  1595-1595   @; label N12_1500 ='First Course Calc Method';
input N12_1510 $  1596-1600   @; label N12_1510 ='Rad--Regional Dose: CGY';
input N12_1520 $  1601-1603   @; label N12_1520 ='Rad--No of Treatment Vol';
input N12_1540 $  1604-1605   @; label N12_1540 ='Rad--Treatment Volume';
input N12_1550 $  1606-1606   @; label N12_1550 ='Rad--Location of RX';
input N12_1570 $  1607-1608   @; label N12_1570 ='Rad--Regional RX Modality';
input N12_3200 $  1609-1610   @; label N12_3200 ='Rad--Boost RX Modality';
input N12_3210 $  1611-1615   @; label N12_3210 ='Rad--Boost Dose cGy';
input N12_1639 $  1616-1616   @; label N12_1639 ='RX Summ--Systemic/Sur Seq';
input N12_1640 $  1617-1618   @; label N12_1640 ='RX Summ--Surgery Type';
input N12_3190 $  1619-1619   @; label N12_3190 ='Readm Same Hosp 30 Days';
input N12_1646 $  1620-1621   @; label N12_1646 ='RX Summ--Surg Site 98-02';
input N12_1647 $  1622-1622   @; label N12_1647 ='RX Summ--Scope Reg 98-02';
input N12_1648 $  1623-1623   @; label N12_1648 ='RX Summ--Surg Oth 98-02';
input N12_1190 $  1624-1723   @; label N12_1190 ='Reserved 06';
input N12_1660 $  1724-1731   @; label N12_1660 ='Subsq RX 2nd Course Date';
input N12_1661 $  1732-1733   @; label N12_1661 ='Subsq RX 2ndCrs Date Flag';
input N12_1670 $  1734-1744   @; label N12_1670 ='Subsq RX 2nd Course Codes';
input N12_1671 $  1734-1735   @; label N12_1671 ='Subsq RX 2nd Course Surg';
input N12_1677 $  1736-1736   @; label N12_1677 ='Subsq RX 2nd--Scope LN SU';
input N12_1678 $  1737-1737   @; label N12_1678 ='Subsq RX 2nd--Surg Oth';
input N12_1679 $  1738-1739   @; label N12_1679 ='Subsq RX 2nd--Reg LN Rem';
input N12_1672 $  1740-1740   @; label N12_1672 ='Subsq RX 2nd Course Rad';
input N12_1673 $  1741-1741   @; label N12_1673 ='Subsq RX 2nd Course Chemo';
input N12_1674 $  1742-1742   @; label N12_1674 ='Subsq RX 2nd Course Horm';
input N12_1675 $  1743-1743   @; label N12_1675 ='Subsq RX 2nd Course BRM';
input N12_1676 $  1744-1744   @; label N12_1676 ='Subsq RX 2nd Course Oth';
input N12_1680 $  1745-1752   @; label N12_1680 ='Subsq RX 3rd Course Date';
input N12_1681 $  1753-1754   @; label N12_1681 ='Subsq RX 3rdCrs Date Flag';
input N12_1690 $  1755-1765   @; label N12_1690 ='Subsq RX 3rd Course Codes';
input N12_1691 $  1755-1756   @; label N12_1691 ='Subsq RX 3rd Course Surg';
input N12_1697 $  1757-1757   @; label N12_1697 ='Subsq RX 3rd--Scope LN Su';
input N12_1698 $  1758-1758   @; label N12_1698 ='Subsq RX 3rd--Surg Oth';
input N12_1699 $  1759-1760   @; label N12_1699 ='Subsq RX 3rd--Reg LN Rem';
input N12_1692 $  1761-1761   @; label N12_1692 ='Subsq RX 3rd Course Rad';
input N12_1693 $  1762-1762   @; label N12_1693 ='Subsq RX 3rd Course Chemo';
input N12_1694 $  1763-1763   @; label N12_1694 ='Subsq RX 3rd Course Horm';
input N12_1695 $  1764-1764   @; label N12_1695 ='Subsq RX 3rd Course BRM';
input N12_1696 $  1765-1765   @; label N12_1696 ='Subsq RX 3rd Course Oth';
input N12_1700 $  1766-1773   @; label N12_1700 ='Subsq RX 4th Course Date';
input N12_1701 $  1774-1775   @; label N12_1701 ='Subsq RX 4thCrs Date Flag';
input N12_1710 $  1776-1786   @; label N12_1710 ='Subsq RX 4th Course Codes';
input N12_1711 $  1776-1777   @; label N12_1711 ='Subsq RX 4th Course Surg';
input N12_1717 $  1778-1778   @; label N12_1717 ='Subsq RX 4th--Scope LN Su';
input N12_1718 $  1779-1779   @; label N12_1718 ='Subsq RX 4th--Surg Oth';
input N12_1719 $  1780-1781   @; label N12_1719 ='Subsq RX 4th--Reg LN Rem';
input N12_1712 $  1782-1782   @; label N12_1712 ='Subsq RX 4th Course Rad';
input N12_1713 $  1783-1783   @; label N12_1713 ='Subsq RX 4th Course Chemo';
input N12_1714 $  1784-1784   @; label N12_1714 ='Subsq RX 4th Course Horm';
input N12_1715 $  1785-1785   @; label N12_1715 ='Subsq RX 4th Course BRM';
input N12_1716 $  1786-1786   @; label N12_1716 ='Subsq RX 4th Course Oth';
input N12_1741 $  1787-1787   @; label N12_1741 ='Subsq RX--Reconstruct Del';
input N12_1300 $  1788-1887   @; label N12_1300 ='Reserved 07';
input N12_1981 $  1888-1888   @; label N12_1981 ='Over-ride SS/NodesPos';
input N12_1982 $  1889-1889   @; label N12_1982 ='Over-ride SS/TNM-N';
input N12_1983 $  1890-1890   @; label N12_1983 ='Over-ride SS/TNM-M';
input N12_1985 $  1891-1891   @; label N12_1985 ='Over-ride Acsn/Class/Seq';
input N12_1986 $  1892-1892   @; label N12_1986 ='Over-ride HospSeq/DxConf';
input N12_1987 $  1893-1893   @; label N12_1987 ='Over-ride CoC-Site/Type';
input N12_1988 $  1894-1894   @; label N12_1988 ='Over-ride HospSeq/Site';
input N12_1989 $  1895-1895   @; label N12_1989 ='Over-ride Site/TNM-StgGrp';
input N12_1990 $  1896-1896   @; label N12_1990 ='Over-ride Age/Site/Morph';
input N12_2000 $  1897-1897   @; label N12_2000 ='Over-ride SeqNo/DxConf';
input N12_2010 $  1898-1898   @; label N12_2010 ='Over-ride Site/Lat/SeqNo';
input N12_2020 $  1899-1899   @; label N12_2020 ='Over-ride Surg/DxConf';
input N12_2030 $  1900-1900   @; label N12_2030 ='Over-ride Site/Type';
input N12_2040 $  1901-1901   @; label N12_2040 ='Over-ride Histology';
input N12_2050 $  1902-1902   @; label N12_2050 ='Over-ride Report Source';
input N12_2060 $  1903-1903   @; label N12_2060 ='Over-ride Ill-define Site';
input N12_2070 $  1904-1904   @; label N12_2070 ='Over-ride Leuk, Lymphoma';
input N12_2071 $  1905-1905   @; label N12_2071 ='Over-ride Site/Behavior';
input N12_2072 $  1906-1906   @; label N12_2072 ='Over-ride Site/EOD/DX Dt';
input N12_2073 $  1907-1907   @; label N12_2073 ='Over-ride Site/Lat/EOD';
input N12_2074 $  1908-1908   @; label N12_2074 ='Over-ride Site/Lat/Morph';
input N12_1960 $  1909-1912   @; label N12_1960 ='Site (73-91) ICD-O-1';
input N12_1970 $  1913-1918   @; label N12_1970 ='Morph (73-91) ICD-O-1';
input N12_1971 $  1913-1916   @; label N12_1971 ='Histology (73-91) ICD-O-1';
input N12_1972 $  1917-1917   @; label N12_1972 ='Behavior (73-91) ICD-O-1';
input N12_1973 $  1918-1918   @; label N12_1973 ='Grade (73-91) ICD-O-1';
input N12_1980 $  1919-1919   @; label N12_1980 ='ICD-O-2 Conversion Flag';
input N12_2081 $  1920-1929   @; label N12_2081 ='CRC CHECKSUM';
input N12_2120 $  1930-1930   @; label N12_2120 ='SEER Coding Sys--Current';
input N12_2130 $  1931-1931   @; label N12_2130 ='SEER Coding Sys--Original';
input N12_2140 $  1932-1933   @; label N12_2140 ='CoC Coding Sys--Current';
input N12_2150 $  1934-1935   @; label N12_2150 ='CoC Coding Sys--Original';
input N12_2170 $  1936-1945   @; label N12_2170 ='Vendor Name';
input N12_2180 $  1946-1946   @; label N12_2180 ='SEER Type of Follow-Up';
input N12_2190 $  1947-1948   @; label N12_2190 ='SEER Record Number';
input N12_2200 $  1949-1950   @; label N12_2200 ='Diagnostic Proc 73-87';
input N12_2085 $  1951-1958   @; label N12_2085 ='Date Case Initiated';
input N12_2090 $  1959-1966   @; label N12_2090 ='Date Case Completed';
input N12_2092 $  1967-1974   @; label N12_2092 ='Date Case Completed--CoC';
input N12_2100 $  1975-1982   @; label N12_2100 ='Date Case Last Changed';
input N12_2110 $  1983-1990   @; label N12_2110 ='Date Case Report Exported';
input N12_2111 $  1991-1998   @; label N12_2111 ='Date Case Report Received';
input N12_2112 $  1999-2006   @; label N12_2112 ='Date Case Report Loaded';
input N12_2113 $  2007-2014   @; label N12_2113 ='Date Tumor Record Availbl';
input N12_2116 $  2015-2015   @; label N12_2116 ='ICD-O-3 Conversion Flag';
input N12_3750 $  2016-2016   @; label N12_3750 ='Over-ride CS 1';
input N12_3751 $  2017-2017   @; label N12_3751 ='Over-ride CS 2';
input N12_3752 $  2018-2018   @; label N12_3752 ='Over-ride CS 3';
input N12_3753 $  2019-2019   @; label N12_3753 ='Over-ride CS 4';
input N12_3754 $  2020-2020   @; label N12_3754 ='Over-ride CS 5';
input N12_3755 $  2021-2021   @; label N12_3755 ='Over-ride CS 6';
input N12_3756 $  2022-2022   @; label N12_3756 ='Over-ride CS 7';
input N12_3757 $  2023-2023   @; label N12_3757 ='Over-ride CS 8';
input N12_3758 $  2024-2024   @; label N12_3758 ='Over-ride CS 9';
input N12_3759 $  2025-2025   @; label N12_3759 ='Over-ride CS 10';
input N12_3760 $  2026-2026   @; label N12_3760 ='Over-ride CS 11';
input N12_3761 $  2027-2027   @; label N12_3761 ='Over-ride CS 12';
input N12_3762 $  2028-2028   @; label N12_3762 ='Over-ride CS 13';
input N12_3763 $  2029-2029   @; label N12_3763 ='Over-ride CS 14';
input N12_3764 $  2030-2030   @; label N12_3764 ='Over-ride CS 15';
input N12_3765 $  2031-2031   @; label N12_3765 ='Over-ride CS 16';
input N12_3766 $  2032-2032   @; label N12_3766 ='Over-ride CS 17';
input N12_3767 $  2033-2033   @; label N12_3767 ='Over-ride CS 18';
input N12_3768 $  2034-2034   @; label N12_3768 ='Over-ride CS 19';
input N12_3769 $  2035-2035   @; label N12_3769 ='Over-ride CS 20';
input N12_1650 $  2036-2115   @; label N12_1650 ='Reserved 08';
input N12_1750 $  2116-2123   @; label N12_1750 ='Date of Last Contact';
input N12_1751 $  2124-2125   @; label N12_1751 ='Date of Last Contact Flag';
input N12_1760 $  2126-2126   @; label N12_1760 ='Vital Status';
input N12_1770 $  2127-2127   @; label N12_1770 ='Cancer Status';
input N12_1780 $  2128-2128   @; label N12_1780 ='Quality of Survival';
input N12_1790 $  2129-2129   @; label N12_1790 ='Follow-Up Source';
input N12_1800 $  2130-2130   @; label N12_1800 ='Next Follow-Up Source';
input N12_1810 $  2131-2180   @; label N12_1810 ='Addr Current--City';
input N12_1820 $  2181-2182   @; label N12_1820 ='Addr Current--State';
input N12_1830 $  2183-2191   @; label N12_1830 ='Addr Current--Postal Code';
input N12_1840 $  2192-2194   @; label N12_1840 ='County--Current';
input N12_1850 $  2195-2195   @; label N12_1850 ='Unusual Follow-Up Method';
input N12_1860 $  2196-2203   @; label N12_1860 ='Recurrence Date--1st';
input N12_1861 $  2204-2205   @; label N12_1861 ='Recurrence Date--1st Flag';
input N12_1880 $  2206-2207   @; label N12_1880 ='Recurrence Type--1st';
input N12_1842 $  2208-2257   @; label N12_1842 ='Follow-Up Contact--City';
input N12_1844 $  2258-2259   @; label N12_1844 ='Follow-Up Contact--State';
input N12_1846 $  2260-2268   @; label N12_1846 ='Follow-Up Contact--Postal';
input N12_1910 $  2269-2272   @; label N12_1910 ='Cause of Death';
input N12_1920 $  2273-2273   @; label N12_1920 ='ICD Revision Number';
input N12_1930 $  2274-2274   @; label N12_1930 ='Autopsy';
input N12_1940 $  2275-2277   @; label N12_1940 ='Place of Death';
input N12_1791 $  2278-2279   @; label N12_1791 ='Follow-up Source Central';
input N12_1755 $  2280-2287   @; label N12_1755 ='Date of Death--Canada';
input N12_1756 $  2288-2289   @; label N12_1756 ='Date of Death--CanadaFlag';
input N12_1740 $  2290-2339   @; label N12_1740 ='Reserved 09';
input N12_2220 $  2340-3339   @; label N12_2220 ='State/Requestor Items';


input N12_2230 $  3340-3379   @; label N12_2230 ='Name--Last';
input N12_2240 $  3380-3419   @; label N12_2240 ='Name--First';
input N12_2250 $  3420-3459   @; label N12_2250 ='Name--Middle';
input N12_2260 $  3460-3462   @; label N12_2260 ='Name--Prefix';
input N12_2270 $  3463-3465   @; label N12_2270 ='Name--Suffix';
input N12_2280 $  3466-3505   @; label N12_2280 ='Name--Alias';
input N12_2390 $  3506-3545   @; label N12_2390 ='Name--Maiden';
input N12_2290 $  3546-3605   @; label N12_2290 ='Name--Spouse/Parent';
input N12_2300 $  3606-3616   @; label N12_2300 ='Medical Record Number';
input N12_2310 $  3617-3618   @; label N12_2310 ='Military Record No Suffix';
input N12_2320 $  3619-3627   @; label N12_2320 ='Social Security Number';
input N12_2330 $  3628-3687   @; label N12_2330 ='Addr at DX--No & Street';
input N12_2335 $  3688-3747   @; label N12_2335 ='Addr at DX--Supplementl';
input N12_2350 $  3748-3807   @; label N12_2350 ='Addr Current--No & Street';
input N12_2355 $  3808-3867   @; label N12_2355 ='Addr Current--Supplementl';
input N12_2360 $  3868-3877   @; label N12_2360 ='Telephone';
input N12_2380 $  3878-3883   @; label N12_2380 ='DC State File Number';
input N12_2394 $  3884-3943   @; label N12_2394 ='Follow-Up Contact--Name';
input N12_2392 $  3944-4003   @; label N12_2392 ='Follow-Up Contact--No&St';
input N12_2393 $  4004-4063   @; label N12_2393 ='Follow-Up Contact--Suppl';
input N12_2352 $  4064-4073   @; label N12_2352 ='Latitude';
input N12_2354 $  4074-4084   @; label N12_2354 ='Longitude';
input N12_1835 $  4085-4284   @; label N12_1835 ='Reserved 10';
input N12_2445 $  4285-4294   @; label N12_2445 ='NPI--Following Registry';
input N12_2440 $  4295-4304   @; label N12_2440 ='Following Registry';
input N12_2415 $  4305-4314   @; label N12_2415 ='NPI--Inst Referred From';
input N12_2410 $  4315-4324   @; label N12_2410 ='Institution Referred From';
input N12_2425 $  4325-4334   @; label N12_2425 ='NPI--Inst Referred To';
input N12_2420 $  4335-4344   @; label N12_2420 ='Institution Referred To';
input N12_1900 $  4345-4394   @; label N12_1900 ='Reserved 11';
input N12_2465 $  4395-4404   @; label N12_2465 ='NPI--Physician--Managing';
input N12_2460 $  4405-4412   @; label N12_2460 ='Physician--Managing';
input N12_2475 $  4413-4422   @; label N12_2475 ='NPI--Physician--Follow-Up';
input N12_2470 $  4423-4430   @; label N12_2470 ='Physician--Follow-Up';
input N12_2485 $  4431-4440   @; label N12_2485 ='NPI--Physician--Primary Surg';
input N12_2480 $  4441-4448   @; label N12_2480 ='Physician--Primary Surg';
input N12_2495 $  4449-4458   @; label N12_2495 ='NPI--Physician 3';
input N12_2490 $  4459-4466   @; label N12_2490 ='Physician 3';
input N12_2505 $  4467-4476   @; label N12_2505 ='NPI--Physician 4';
input N12_2500 $  4477-4484   @; label N12_2500 ='Physician 4';
input N12_2510 $  4485-4534   @; label N12_2510 ='Reserved 12';
input N12_7010 $  4535-4559   @; label N12_7010 ='Path Reporting Fac ID 1';
input N12_7090 $  4560-4579   @; label N12_7090 ='Path Report Number 1';
input N12_7320 $  4580-4593   @; label N12_7320 ='Path Date Spec Collect 1';
input N12_7480 $  4594-4595   @; label N12_7480 ='Path Report Type 1';
input N12_7190 $  4596-4620   @; label N12_7190 ='Path Ordering Fac No 1';
input N12_7100 $  4621-4640   @; label N12_7100 ='Path Order Phys Lic No 1';
input N12_7011 $  4641-4665   @; label N12_7011 ='Path Reporting Fac ID 2';
input N12_7091 $  4666-4685   @; label N12_7091 ='Path Report Number 2';
input N12_7321 $  4686-4699   @; label N12_7321 ='Path Date Spec Collect 2';
input N12_7481 $  4700-4701   @; label N12_7481 ='Path Report Type 2';
input N12_7191 $  4702-4726   @; label N12_7191 ='Path Ordering Fac No 2';
input N12_7101 $  4727-4746   @; label N12_7101 ='Path Order Phys Lic No 2';
input N12_7012 $  4747-4771   @; label N12_7012 ='Path Reporting Fac ID 3';
input N12_7092 $  4772-4791   @; label N12_7092 ='Path Report Number 3';
input N12_7322 $  4792-4805   @; label N12_7322 ='Path Date Spec Collect 3';
input N12_7482 $  4806-4807   @; label N12_7482 ='Path Report Type 3';
input N12_7192 $  4808-4832   @; label N12_7192 ='Path Ordering Fac No 3';
input N12_7102 $  4833-4852   @; label N12_7102 ='Path Order Phys Lic No 3';
input N12_7013 $  4853-4877   @; label N12_7013 ='Path Reporting Fac ID 4';
input N12_7093 $  4878-4897   @; label N12_7093 ='Path Report Number 4';
input N12_7323 $  4898-4911   @; label N12_7323 ='Path Date Spec Collect 4';
input N12_7483 $  4912-4913   @; label N12_7483 ='Path Report Type 4';
input N12_7193 $  4914-4938   @; label N12_7193 ='Path Ordering Fac No 4';
input N12_7103 $  4939-4958   @; label N12_7103 ='Path Order Phys Lic No 4';
input N12_7014 $  4959-4983   @; label N12_7014 ='Path Reporting Fac ID 5';
input N12_7094 $  4984-5003   @; label N12_7094 ='Path Report Number 5';
input N12_7324 $  5004-5017   @; label N12_7324 ='Path Date Spec Collect 5';
input N12_7484 $  5018-5019   @; label N12_7484 ='Path Report Type 5';
input N12_7194 $  5020-5044   @; label N12_7194 ='Path Ordering Fac No 5';
input N12_7104 $  5045-5064   @; label N12_7104 ='Path Order Phys Lic No 5';
input N12_2080 $  5065-5564   @; label N12_2080 ='Reserved 13';

/*
input N12_2520 $  5565-6564   @; label N12_2520 ='Text--DX Proc--PE';
input N12_2530 $  6565-7564   @; label N12_2530 ='Text--DX Proc--X-ray/Scan';
input N12_2540 $  7565-8564   @; label N12_2540 ='Text--DX Proc--Scopes';
input N12_2550 $  8565-9564   @; label N12_2550 ='Text--DX Proc--Lab Tests';
input N12_2560 $  9565-10564  @; label N12_2560 ='Text--DX Proc--Op';
input N12_2570 $  10565-11564 @; label N12_2570 ='Text--DX Proc--Path';
input N12_2580 $  11565-11664 @; label N12_2580 ='Text--Primary Site Title';
input N12_2590 $  11665-11764 @; label N12_2590 ='Text--Histology Title';
input N12_2600 $  11765-12764 @; label N12_2600 ='Text--Staging';
input N12_2610 $  12765-13764 @; label N12_2610 ='RX Text--Surgery';
input N12_2620 $  13765-14764 @; label N12_2620 ='RX Text--Radiation (Beam)';
input N12_2630 $  14765-15764 @; label N12_2630 ='RX Text--Radiation Other';
input N12_2640 $  15765-16764 @; label N12_2640 ='RX Text--Chemo';
input N12_2650 $  16765-17764 @; label N12_2650 ='RX Text--Hormone';
input N12_2660 $  17765-18764 @; label N12_2660 ='RX Text--BRM';
input N12_2670 $  18765-19764 @; label N12_2670 ='RX Text--Other';
input N12_2680 $  19765-20764 @; label N12_2680 ='Text--Remarks';
input N12_2690 $  20765-20824 @; label N12_2690 ='Text--Place of Diagnosis';
input N12_2210 $  20825-22824 @; label N12_2210 ='Reserved 14';
*/

/* ADDITIONAL RMCDS VARIABLES IN RECORD */
input   masterfn   $3332-3339   @;  label  masterfn  ='RMCDS MASTER FILE NUMBER';
input   NPAIHBlink $2350-2350   @;  label  NPAIHBlink='NPAIHB 1=Yes';

/* ADDITIONAL USEFUL VARIABLES IN RECORD */
input   dx_year    $530-533     @;  label  dx_year   ='YEAR OF DIAGNOSIS';
input   ZIPCode    $147-151     @;  label  ZIPCode   ='ZIP CODE 5-DIGIT';  

*-----------------------------------------------*
/*   Alternate Input statements - prepends labels with NAACCR Item# 


input N12_10   $  1-1         @; label N12_10	='10_Record Type';
input N12_30   $  2-2         @; label N12_30	='30_Registry Type';
input N12_35   $  3-3         @; label N12_35	='35_FIN Coding System';
input N12_37   $  4-16        @; label N12_37	='37_Reserved 00';
input N12_50   $  17-19       @; label N12_50	='50_NAACCR Record Version';
input N12_45   $  20-29       @; label N12_45	='45_NPI--Registry ID';
input N12_40   $  30-39       @; label N12_40	='40_Registry ID';
input N12_60   $  40-41       @; label N12_60	='60_Tumor Record Number';
input N12_20   $  42-49       @; label N12_20	='20_Patient ID Number';
input N12_21   $  50-57       @; label N12_21	='21_Patient System ID-Hosp';
input N12_370  $  58-94       @; label N12_370	='370_Reserved 01';
input N12_70   $  95-144      @; label N12_70	='70_Addr at DX--City';
input N12_80   $  145-146     @; label N12_80	='80_Addr at DX--State';
input N12_100  $  147-155     @; label N12_100	='100_Addr at DX--Postal Code';
input N12_90   $  156-158     @; label N12_90	='90_County at DX';
input N12_110  $  159-164     @; label N12_110	='110_Census Tract 1970/80/90';
input N12_368  $  165-165     @; label N12_368	='368_CensusBlockGroup 70/80/90';
input N12_120  $  166-166     @; label N12_120	='120_Census Cod Sys 1970/80/90';
input N12_364  $  167-167     @; label N12_364	='364_Census Tr Cert 1970/80/90';
input N12_130  $  168-173     @; label N12_130	='130_Census Tract 2000';
input N12_362  $  174-174     @; label N12_362	='362_Census Block Group 2000';
input N12_365  $  175-175     @; label N12_365	='365_Census Tr Certainty 2000';
input N12_150  $  176-176     @; label N12_150	='150_Marital Status at DX';
input N12_160  $  177-178     @; label N12_160	='160_Race 1';
input N12_161  $  179-180     @; label N12_161	='161_Race 2';
input N12_162  $  181-182     @; label N12_162	='162_Race 3';
input N12_163  $  183-184     @; label N12_163	='163_Race 4';
input N12_164  $  185-186     @; label N12_164	='164_Race 5';
input N12_170  $  187-187     @; label N12_170	='170_Race Coding Sys--Current';
input N12_180  $  188-188     @; label N12_180	='180_Race Coding Sys--Original';
input N12_190  $  189-189     @; label N12_190	='190_Spanish/Hispanic Origin';
input N12_200  $  190-190     @; label N12_200	='200_Computed Ethnicity';
input N12_210  $  191-191     @; label N12_210	='210_Computed Ethnicity Source';
input N12_220  $  192-192     @; label N12_220	='220_Sex';
input N12_230  $  193-195     @; label N12_230	='230_Age at Diagnosis';
input N12_240  $  196-203     @; label N12_240	='240_Date of Birth';
input N12_241  $  204-205     @; label N12_241	='241_Date of Birth Flag';
input N12_250  $  206-208     @; label N12_250	='250_Birthplace';
input N12_270  $  209-211     @; label N12_270	='270_Occupation Code--Census';
input N12_280  $  212-214     @; label N12_280	='280_Industry Code--Census';
input N12_290  $  215-215     @; label N12_290	='290_Occupation Source';
input N12_300  $  216-216     @; label N12_300	='300_Industry Source';
input N12_310  $  217-316     @; label N12_310	='310_Text--Usual Occupation';
input N12_320  $  317-416     @; label N12_320	='320_Text--Usual Industry';
input N12_330  $  417-417     @; label N12_330	='330_Occup/Ind Coding System';
input N12_191  $  418-418     @; label N12_191	='191_NHIA Derived Hisp Origin';
input N12_193  $  419-420     @; label N12_193	='193_Race--NAPIIA(derived API)';
input N12_192  $  421-421     @; label N12_192	='192_IHS Link';
input N12_366  $  422-423     @; label N12_366	='366_GIS Coordinate Quality';
input N12_3300 $  424-425     @; label N12_3300	='3300_RuralUrban Continuum 1993';
input N12_3310 $  426-427     @; label N12_3310	='3310_RuralUrban Continuum 2003';
input N12_135  $  428-433     @; label N12_135	='135_Census Tract 2010';
input N12_363  $  434-434     @; label N12_363	='363_Census Block Group 2010';
input N12_367  $  435-435     @; label N12_367	='367_Census Tr Certainty 2010';
input N12_530  $  436-527     @; label N12_530	='530_Reserved 02';
input N12_380  $  528-529     @; label N12_380	='380_Sequence Number--Central';
input N12_390  $  530-537     @; label N12_390	='390_Date of Diagnosis';
input N12_391  $  538-539     @; label N12_391	='391_Date of Diagnosis Flag';
input N12_400  $  540-543     @; label N12_400	='400_Primary Site';
input N12_410  $  544-544     @; label N12_410	='410_Laterality';
input N12_419  $  545-549     @; label N12_419	='419_Morph--Type&Behav ICD-O-2';
input N12_420  $  545-548     @; label N12_420	='420_Histology (92-00) ICD-O-2';
input N12_430  $  549-549     @; label N12_430	='430_Behavior (92-00) ICD-O-2';
input N12_521  $  550-554     @; label N12_521	='521_Morph--Type&Behav ICD-O-3';
input N12_522  $  550-553     @; label N12_522	='522_Histologic Type ICD-O-3';
input N12_523  $  554-554     @; label N12_523	='523_Behavior Code ICD-O-3';
input N12_440  $  555-555     @; label N12_440	='440_Grade';
input N12_441  $  556-556     @; label N12_441	='441_Grade Path Value';
input N12_449  $  557-557     @; label N12_449	='449_Grade Path System';
input N12_450  $  558-558     @; label N12_450	='450_Site Coding Sys--Current';
input N12_460  $  559-559     @; label N12_460	='460_Site Coding Sys--Original';
input N12_470  $  560-560     @; label N12_470	='470_Morph Coding Sys--Current';
input N12_480  $  561-561     @; label N12_480	='480_Morph Coding Sys--Originl';
input N12_490  $  562-562     @; label N12_490	='490_Diagnostic Confirmation';
input N12_500  $  563-563     @; label N12_500	='500_Type of Reporting Source';
input N12_501  $  564-565     @; label N12_501	='501_Casefinding Source';
input N12_442  $  566-566     @; label N12_442	='442_Ambiguous Terminology DX';
input N12_443  $  567-574     @; label N12_443	='443_Date of Conclusive DX';
input N12_448  $  575-576     @; label N12_448	='448_Date Conclusive DX Flag';
input N12_444  $  577-578     @; label N12_444	='444_Mult Tum Rpt as One Prim';
input N12_445  $  579-586     @; label N12_445	='445_Date of Multiple Tumors';
input N12_439  $  587-588     @; label N12_439	='439_Date of Mult Tumors Flag';
input N12_446  $  589-590     @; label N12_446	='446_Multiplicity Counter';
input N12_680  $  591-690     @; label N12_680	='680_Reserved 03';
input N12_545  $  691-700     @; label N12_545	='545_NPI--Reporting Facility';
input N12_540  $  701-710     @; label N12_540	='540_Reporting Facility';
input N12_3105 $  711-720     @; label N12_3105	='3105_NPI--Archive FIN';
input N12_3100 $  721-730     @; label N12_3100	='3100_Archive FIN';
input N12_550  $  731-739     @; label N12_550	='550_Accession Number--Hosp';
input N12_560  $  740-741     @; label N12_560	='560_Sequence Number--Hospital';
input N12_570  $  742-744     @; label N12_570	='570_Abstracted By';
input N12_580  $  745-752     @; label N12_580	='580_Date of 1st Contact';
input N12_581  $  753-754     @; label N12_581	='581_Date of 1st Contact Flag';
input N12_590  $  755-762     @; label N12_590	='590_Date of Inpatient Adm';
input N12_591  $  763-764     @; label N12_591	='591_Date of Inpt Adm Flag';
input N12_600  $  765-772     @; label N12_600	='600_Date of Inpatient Disch';
input N12_601  $  773-774     @; label N12_601	='601_Date of Inpt Disch Flag';
input N12_605  $  775-775     @; label N12_605	='605_Inpatient Status';
input N12_610  $  776-777     @; label N12_610	='610_Class of Case';
input N12_630  $  778-779     @; label N12_630	='630_Primary Payer at DX';
input N12_2400 $  780-780     @; label N12_2400	='2400_Reserved 16';
input N12_668  $  781-781     @; label N12_668	='668_RX Hosp--Surg App 2010';
input N12_670  $  782-783     @; label N12_670	='670_RX Hosp--Surg Prim Site';
input N12_672  $  784-784     @; label N12_672	='672_RX Hosp--Scope Reg LN Sur';
input N12_674  $  785-785     @; label N12_674	='674_RX Hosp--Surg Oth Reg/Dis';
input N12_676  $  786-787     @; label N12_676	='676_RX Hosp--Reg LN Removed';
input N12_2450 $  788-788     @; label N12_2450	='2450_Reserved 17';
input N12_690  $  789-789     @; label N12_690	='690_RX Hosp--Radiation';
input N12_700  $  790-791     @; label N12_700	='700_RX Hosp--Chemo';
input N12_710  $  792-793     @; label N12_710	='710_RX Hosp--Hormone';
input N12_720  $  794-795     @; label N12_720	='720_RX Hosp--BRM';
input N12_730  $  796-796     @; label N12_730	='730_RX Hosp--Other';
input N12_740  $  797-798     @; label N12_740	='740_RX Hosp--DX/Stg Proc';
input N12_3280 $  799-799     @; label N12_3280	='3280_RX Hosp--Palliative Proc';
input N12_746  $  800-801     @; label N12_746	='746_RX Hosp--Surg Site 98-02';
input N12_747  $  802-802     @; label N12_747	='747_RX Hosp--Scope Reg 98-02';
input N12_748  $  803-803     @; label N12_748	='748_RX Hosp--Surg Oth 98-02';
input N12_750  $  804-903     @; label N12_750	='750_Reserved 04';
input N12_759  $  904-904     @; label N12_759	='759_SEER Summary Stage 2000';
input N12_760  $  905-905     @; label N12_760	='760_SEER Summary Stage 1977';
input N12_779  $  906-917     @; label N12_779	='779_Extent of Disease 10-Dig';
input N12_780  $  906-908     @; label N12_780	='780_EOD--Tumor Size';
input N12_790  $  909-910     @; label N12_790	='790_EOD--Extension';
input N12_800  $  911-912     @; label N12_800	='800_EOD--Extension Prost Path';
input N12_810  $  913-913     @; label N12_810	='810_EOD--Lymph Node Involv';
input N12_820  $  914-915     @; label N12_820	='820_Regional Nodes Positive';
input N12_830  $  916-917     @; label N12_830	='830_Regional Nodes Examined';
input N12_840  $  918-930     @; label N12_840	='840_EOD--Old 13 Digit';
input N12_850  $  931-932     @; label N12_850	='850_EOD--Old 2 Digit';
input N12_860  $  933-936     @; label N12_860	='860_EOD--Old 4 Digit';
input N12_870  $  937-937     @; label N12_870	='870_Coding System for EOD';
input N12_1060 $  938-939     @; label N12_1060	='1060_TNM Edition Number';
input N12_880  $  940-943     @; label N12_880	='880_TNM Path T';
input N12_890  $  944-947     @; label N12_890	='890_TNM Path N';
input N12_900  $  948-951     @; label N12_900	='900_TNM Path M';
input N12_910  $  952-955     @; label N12_910	='910_TNM Path Stage Group';
input N12_920  $  956-956     @; label N12_920	='920_TNM Path Descriptor';
input N12_930  $  957-957     @; label N12_930	='930_TNM Path Staged By';
input N12_940  $  958-961     @; label N12_940	='940_TNM Clin T';
input N12_950  $  962-965     @; label N12_950	='950_TNM Clin N';
input N12_960  $  966-969     @; label N12_960	='960_TNM Clin M';
input N12_970  $  970-973     @; label N12_970	='970_TNM Clin Stage Group';
input N12_980  $  974-974     @; label N12_980	='980_TNM Clin Descriptor';
input N12_990  $  975-975     @; label N12_990	='990_TNM Clin Staged By';
input N12_1120 $  976-977     @; label N12_1120	='1120_Pediatric Stage';
input N12_1130 $  978-979     @; label N12_1130	='1130_Pediatric Staging System';
input N12_1140 $  980-980     @; label N12_1140	='1140_Pediatric Staged By';
input N12_1150 $  981-981     @; label N12_1150	='1150_Tumor Marker 1';
input N12_1160 $  982-982     @; label N12_1160	='1160_Tumor Marker 2';
input N12_1170 $  983-983     @; label N12_1170	='1170_Tumor Marker 3';
input N12_1182 $  984-984     @; label N12_1182	='1182_Lymph-vascular Invasion';
input N12_2800 $  985-987     @; label N12_2800	='2800_CS Tumor Size';
input N12_2810 $  988-990     @; label N12_2810	='2810_CS Extension';
input N12_2820 $  991-991     @; label N12_2820	='2820_CS Tumor Size/Ext Eval';
input N12_2830 $  992-994     @; label N12_2830	='2830_CS Lymph Nodes';
input N12_2840 $  995-995     @; label N12_2840	='2840_CS Lymph Nodes Eval';
input N12_2850 $  996-997     @; label N12_2850	='2850_CS Mets at DX';
input N12_2860 $  998-998     @; label N12_2860	='2860_CS Mets Eval';
input N12_2851 $  999-999     @; label N12_2851	='2851_CS Mets at Dx-Bone';
input N12_2852 $  1000-1000   @; label N12_2852	='2852_CS Mets at Dx-Brain';
input N12_2853 $  1001-1001   @; label N12_2853	='2853_CS Mets at Dx-Liver';
input N12_2854 $  1002-1002   @; label N12_2854	='2854_CS Mets at Dx-Lung';
input N12_2880 $  1003-1005   @; label N12_2880	='2880_CS Site-Specific Factor 1';
input N12_2890 $  1006-1008   @; label N12_2890	='2890_CS Site-Specific Factor 2';
input N12_2900 $  1009-1011   @; label N12_2900	='2900_CS Site-Specific Factor 3';
input N12_2910 $  1012-1014   @; label N12_2910	='2910_CS Site-Specific Factor 4';
input N12_2920 $  1015-1017   @; label N12_2920	='2920_CS Site-Specific Factor 5';
input N12_2930 $  1018-1020   @; label N12_2930	='2930_CS Site-Specific Factor 6';
input N12_2861 $  1021-1023   @; label N12_2861	='2861_CS Site-Specific Factor 7';
input N12_2862 $  1024-1026   @; label N12_2862	='2862_CS Site-Specific Factor 8';
input N12_2863 $  1027-1029   @; label N12_2863	='2863_CS Site-Specific Factor 9';
input N12_2864 $  1030-1032   @; label N12_2864	='2864_CS Site-Specific Factor10';
input N12_2865 $  1033-1035   @; label N12_2865	='2865_CS Site-Specific Factor11';
input N12_2866 $  1036-1038   @; label N12_2866	='2866_CS Site-Specific Factor12';
input N12_2867 $  1039-1041   @; label N12_2867	='2867_CS Site-Specific Factor13';
input N12_2868 $  1042-1044   @; label N12_2868	='2868_CS Site-Specific Factor14';
input N12_2869 $  1045-1047   @; label N12_2869	='2869_CS Site-Specific Factor15';
input N12_2870 $  1048-1050   @; label N12_2870	='2870_CS Site-Specific Factor16';
input N12_2871 $  1051-1053   @; label N12_2871	='2871_CS Site-Specific Factor17';
input N12_2872 $  1054-1056   @; label N12_2872	='2872_CS Site-Specific Factor18';
input N12_2873 $  1057-1059   @; label N12_2873	='2873_CS Site-Specific Factor19';
input N12_2874 $  1060-1062   @; label N12_2874	='2874_CS Site-Specific Factor20';
input N12_2875 $  1063-1065   @; label N12_2875	='2875_CS Site-Specific Factor21';
input N12_2876 $  1066-1068   @; label N12_2876	='2876_CS Site-Specific Factor22';
input N12_2877 $  1069-1071   @; label N12_2877	='2877_CS Site-Specific Factor23';
input N12_2878 $  1072-1074   @; label N12_2878	='2878_CS Site-Specific Factor24';
input N12_2879 $  1075-1077   @; label N12_2879	='2879_CS Site-Specific Factor25';
input N12_2730 $  1078-1080   @; label N12_2730	='2730_CS PreRx Tumor Size';
input N12_2735 $  1081-1083   @; label N12_2735	='2735_CS PreRx Extension';
input N12_2740 $  1084-1084   @; label N12_2740	='2740_CS PreRx Tum Sz/Ext Eval';
input N12_2750 $  1085-1087   @; label N12_2750	='2750_CS PreRx Lymph Nodes';
input N12_2755 $  1088-1088   @; label N12_2755	='2755_CS PreRx Reg Nodes Eval';
input N12_2760 $  1089-1090   @; label N12_2760	='2760_CS PreRx Mets at DX';
input N12_2765 $  1091-1091   @; label N12_2765	='2765_CS PreRx Mets Eval';
input N12_2770 $  1092-1094   @; label N12_2770	='2770_CS PostRx Tumor Size';
input N12_2775 $  1095-1097   @; label N12_2775	='2775_CS PostRx Extension';
input N12_2780 $  1098-1100   @; label N12_2780	='2780_CS PostRx Lymph Nodes';
input N12_2785 $  1101-1102   @; label N12_2785	='2785_CS PostRx Mets at DX';
input N12_2940 $  1103-1104   @; label N12_2940	='2940_Derived AJCC-6 T';
input N12_2950 $  1105-1105   @; label N12_2950	='2950_Derived AJCC-6 T Descript';
input N12_2960 $  1106-1107   @; label N12_2960	='2960_Derived AJCC-6 N';
input N12_2970 $  1108-1108   @; label N12_2970	='2970_Derived AJCC-6 N Descript';
input N12_2980 $  1109-1110   @; label N12_2980	='2980_Derived AJCC-6 M';
input N12_2990 $  1111-1111   @; label N12_2990	='2990_Derived AJCC-6 M Descript';
input N12_3000 $  1112-1113   @; label N12_3000	='3000_Derived AJCC-6 Stage Grp';
input N12_3400 $  1114-1116   @; label N12_3400	='3400_Derived AJCC-7 T';
input N12_3402 $  1117-1117   @; label N12_3402	='3402_Derived AJCC-7 T Descript';
input N12_3410 $  1118-1120   @; label N12_3410	='3410_Derived AJCC-7 N';
input N12_3412 $  1121-1121   @; label N12_3412	='3412_Derived AJCC-7 N Descript';
input N12_3420 $  1122-1124   @; label N12_3420	='3420_Derived AJCC-7 M';
input N12_3422 $  1125-1125   @; label N12_3422	='3422_Derived AJCC-7 M Descript';
input N12_3430 $  1126-1128   @; label N12_3430	='3430_Derived AJCC-7 Stage Grp';
input N12_3440 $  1129-1131   @; label N12_3440	='3440_Derived PreRx-7 T';
input N12_3442 $  1132-1132   @; label N12_3442	='3442_Derived PreRx-7 T Descrip';
input N12_3450 $  1133-1135   @; label N12_3450	='3450_Derived PreRx-7 N';
input N12_3452 $  1136-1136   @; label N12_3452	='3452_Derived PreRx-7 N Descrip';
input N12_3460 $  1137-1139   @; label N12_3460	='3460_Derived PreRx-7 M';
input N12_3462 $  1140-1140   @; label N12_3462	='3462_Derived PreRx-7 M Descrip';
input N12_3470 $  1141-1143   @; label N12_3470	='3470_Derived PreRx-7 Stage Grp';
input N12_3480 $  1144-1146   @; label N12_3480	='3480_Derived PostRx-7 T';
input N12_3482 $  1147-1149   @; label N12_3482	='3482_Derived PostRx-7 N';
input N12_3490 $  1150-1151   @; label N12_3490	='3490_Derived PostRx-7 M';
input N12_3492 $  1152-1154   @; label N12_3492	='3492_Derived PostRx-7 Stge Grp';
input N12_3010 $  1155-1155   @; label N12_3010	='3010_Derived SS1977';
input N12_3020 $  1156-1156   @; label N12_3020	='3020_Derived SS2000';
input N12_3600 $  1157-1157   @; label N12_3600	='3600_Derived Neoadjuv Rx Flag';
input N12_3030 $  1158-1158   @; label N12_3030	='3030_Derived AJCC--Flag';
input N12_3040 $  1159-1159   @; label N12_3040	='3040_Derived SS1977--Flag';
input N12_3050 $  1160-1160   @; label N12_3050	='3050_Derived SS2000--Flag';
input N12_2937 $  1161-1166   @; label N12_2937	='2937_CS Version Input Current';
input N12_2935 $  1167-1172   @; label N12_2935	='2935_CS Version Input Original';
input N12_2936 $  1173-1178   @; label N12_2936	='2936_CS Version Derived';
input N12_3700 $  1179-1179   @; label N12_3700	='3700_SEER Site-Specific Fact 1';
input N12_3702 $  1180-1180   @; label N12_3702	='3702_SEER Site-Specific Fact 2';
input N12_3704 $  1181-1181   @; label N12_3704	='3704_SEER Site-Specific Fact 3';
input N12_3706 $  1182-1182   @; label N12_3706	='3706_SEER Site-Specific Fact 4';
input N12_3708 $  1183-1183   @; label N12_3708	='3708_SEER Site-Specific Fact 5';
input N12_3710 $  1184-1184   @; label N12_3710	='3710_SEER Site-Specific Fact 6';
input N12_3165 $  1185-1185   @; label N12_3165	='3165_ICD Revision Comorbid';
input N12_3110 $  1186-1190   @; label N12_3110	='3110_Comorbid/Complication 1';
input N12_3120 $  1191-1195   @; label N12_3120	='3120_Comorbid/Complication 2';
input N12_3130 $  1196-1200   @; label N12_3130	='3130_Comorbid/Complication 3';
input N12_3140 $  1201-1205   @; label N12_3140	='3140_Comorbid/Complication 4';
input N12_3150 $  1206-1210   @; label N12_3150	='3150_Comorbid/Complication 5';
input N12_3160 $  1211-1215   @; label N12_3160	='3160_Comorbid/Complication 6';
input N12_3161 $  1216-1220   @; label N12_3161	='3161_Comorbid/Complication 7';
input N12_3162 $  1221-1225   @; label N12_3162	='3162_Comorbid/Complication 8';
input N12_3163 $  1226-1230   @; label N12_3163	='3163_Comorbid/Complication 9';
input N12_3164 $  1231-1235   @; label N12_3164	='3164_Comorbid/Complication 10';
input N12_1180 $  1236-1435   @; label N12_1180	='1180_Reserved 05';
input N12_1260 $  1436-1443   @; label N12_1260	='1260_Date of Initial RX--SEER';
input N12_1261 $  1444-1445   @; label N12_1261	='1261_Date of Initial RX Flag';
input N12_1270 $  1446-1453   @; label N12_1270	='1270_Date of 1st Crs RX--CoC';
input N12_1271 $  1454-1455   @; label N12_1271	='1271_Date of 1st Crs Rx Flag';
input N12_1200 $  1456-1463   @; label N12_1200	='1200_RX Date--Surgery';
input N12_1201 $  1464-1465   @; label N12_1201	='1201_RX Date--Surgery Flag';
input N12_3170 $  1466-1473   @; label N12_3170	='3170_RX Date--Most Defin Surg';
input N12_3171 $  1474-1475   @; label N12_3171	='3171_RX Date Mst Defn Srg Flag';
input N12_3180 $  1476-1483   @; label N12_3180	='3180_RX Date--Surgical Disch';
input N12_3181 $  1484-1485   @; label N12_3181	='3181_RX Date Surg Disch Flag';
input N12_1210 $  1486-1493   @; label N12_1210	='1210_RX Date--Radiation';
input N12_1211 $  1494-1495   @; label N12_1211	='1211_RX Date--Radiation Flag';
input N12_3220 $  1496-1503   @; label N12_3220	='3220_RX Date--Radiation Ended';
input N12_3221 $  1504-1505   @; label N12_3221	='3221_RX Date Rad Ended Flag';
input N12_3230 $  1506-1513   @; label N12_3230	='3230_RX Date--Systemic';
input N12_3231 $  1514-1515   @; label N12_3231	='3231_RX Date Systemic Flag';
input N12_1220 $  1516-1523   @; label N12_1220	='1220_RX Date--Chemo';
input N12_1221 $  1524-1525   @; label N12_1221	='1221_RX Date--Chemo Flag';
input N12_1230 $  1526-1533   @; label N12_1230	='1230_RX Date--Hormone';
input N12_1231 $  1534-1535   @; label N12_1231	='1231_RX Date--Hormone Flag';
input N12_1240 $  1536-1543   @; label N12_1240	='1240_RX Date--BRM';
input N12_1241 $  1544-1545   @; label N12_1241	='1241_RX Date--BRM Flag';
input N12_1250 $  1546-1553   @; label N12_1250	='1250_RX Date--Other';
input N12_1251 $  1554-1555   @; label N12_1251	='1251_RX Date--Other Flag';
input N12_1280 $  1556-1563   @; label N12_1280	='1280_RX Date--DX/Stg Proc';
input N12_1281 $  1564-1565   @; label N12_1281	='1281_RX Date--Dx/Stg Proc Flag';
input N12_1285 $  1566-1566   @; label N12_1285	='1285_RX Summ--Treatment Status';
input N12_1290 $  1567-1568   @; label N12_1290	='1290_RX Summ--Surg Prim Site';
input N12_1292 $  1569-1569   @; label N12_1292	='1292_RX Summ--Scope Reg LN Sur';
input N12_1294 $  1570-1570   @; label N12_1294	='1294_RX Summ--Surg Oth Reg/Dis';
input N12_1296 $  1571-1572   @; label N12_1296	='1296_RX Summ--Reg LN Examined';
input N12_1310 $  1573-1573   @; label N12_1310	='1310_RX Summ--Surgical Approch';
input N12_1320 $  1574-1574   @; label N12_1320	='1320_RX Summ--Surgical Margins';
input N12_1330 $  1575-1575   @; label N12_1330	='1330_RX Summ--Reconstruct 1st';
input N12_1340 $  1576-1576   @; label N12_1340	='1340_Reason for No Surgery';
input N12_1350 $  1577-1578   @; label N12_1350	='1350_RX Summ--DX/Stg Proc';
input N12_3270 $  1579-1579   @; label N12_3270	='3270_RX Summ--Palliative Proc';
input N12_1360 $  1580-1580   @; label N12_1360	='1360_RX Summ--Radiation';
input N12_1370 $  1581-1581   @; label N12_1370	='1370_RX Summ--Rad to CNS';
input N12_1380 $  1582-1582   @; label N12_1380	='1380_RX Summ--Surg/Rad Seq';
input N12_3250 $  1583-1584   @; label N12_3250	='3250_RX Summ--Transplnt/Endocr';
input N12_1390 $  1585-1586   @; label N12_1390	='1390_RX Summ--Chemo';
input N12_1400 $  1587-1588   @; label N12_1400	='1400_RX Summ--Hormone';
input N12_1410 $  1589-1590   @; label N12_1410	='1410_RX Summ--BRM';
input N12_1420 $  1591-1591   @; label N12_1420	='1420_RX Summ--Other';
input N12_1430 $  1592-1592   @; label N12_1430	='1430_Reason for No Radiation';
input N12_1460 $  1593-1594   @; label N12_1460	='1460_RX Coding System--Current';
input N12_1500 $  1595-1595   @; label N12_1500	='1500_First Course Calc Method';
input N12_1510 $  1596-1600   @; label N12_1510	='1510_Rad--Regional Dose: CGY';
input N12_1520 $  1601-1603   @; label N12_1520	='1520_Rad--No of Treatment Vol';
input N12_1540 $  1604-1605   @; label N12_1540	='1540_Rad--Treatment Volume';
input N12_1550 $  1606-1606   @; label N12_1550	='1550_Rad--Location of RX';
input N12_1570 $  1607-1608   @; label N12_1570	='1570_Rad--Regional RX Modality';
input N12_3200 $  1609-1610   @; label N12_3200	='3200_Rad--Boost RX Modality';
input N12_3210 $  1611-1615   @; label N12_3210	='3210_Rad--Boost Dose cGy';
input N12_1639 $  1616-1616   @; label N12_1639	='1639_RX Summ--Systemic/Sur Seq';
input N12_1640 $  1617-1618   @; label N12_1640	='1640_RX Summ--Surgery Type';
input N12_3190 $  1619-1619   @; label N12_3190	='3190_Readm Same Hosp 30 Days';
input N12_1646 $  1620-1621   @; label N12_1646	='1646_RX Summ--Surg Site 98-02';
input N12_1647 $  1622-1622   @; label N12_1647	='1647_RX Summ--Scope Reg 98-02';
input N12_1648 $  1623-1623   @; label N12_1648	='1648_RX Summ--Surg Oth 98-02';
input N12_1190 $  1624-1723   @; label N12_1190	='1190_Reserved 06';
input N12_1660 $  1724-1731   @; label N12_1660	='1660_Subsq RX 2nd Course Date';
input N12_1661 $  1732-1733   @; label N12_1661	='1661_Subsq RX 2ndCrs Date Flag';
input N12_1670 $  1734-1744   @; label N12_1670	='1670_Subsq RX 2nd Course Codes';
input N12_1671 $  1734-1735   @; label N12_1671	='1671_Subsq RX 2nd Course Surg';
input N12_1677 $  1736-1736   @; label N12_1677	='1677_Subsq RX 2nd--Scope LN SU';
input N12_1678 $  1737-1737   @; label N12_1678	='1678_Subsq RX 2nd--Surg Oth';
input N12_1679 $  1738-1739   @; label N12_1679	='1679_Subsq RX 2nd--Reg LN Rem';
input N12_1672 $  1740-1740   @; label N12_1672	='1672_Subsq RX 2nd Course Rad';
input N12_1673 $  1741-1741   @; label N12_1673	='1673_Subsq RX 2nd Course Chemo';
input N12_1674 $  1742-1742   @; label N12_1674	='1674_Subsq RX 2nd Course Horm';
input N12_1675 $  1743-1743   @; label N12_1675	='1675_Subsq RX 2nd Course BRM';
input N12_1676 $  1744-1744   @; label N12_1676	='1676_Subsq RX 2nd Course Oth';
input N12_1680 $  1745-1752   @; label N12_1680	='1680_Subsq RX 3rd Course Date';
input N12_1681 $  1753-1754   @; label N12_1681	='1681_Subsq RX 3rdCrs Date Flag';
input N12_1690 $  1755-1765   @; label N12_1690	='1690_Subsq RX 3rd Course Codes';
input N12_1691 $  1755-1756   @; label N12_1691	='1691_Subsq RX 3rd Course Surg';
input N12_1697 $  1757-1757   @; label N12_1697	='1697_Subsq RX 3rd--Scope LN Su';
input N12_1698 $  1758-1758   @; label N12_1698	='1698_Subsq RX 3rd--Surg Oth';
input N12_1699 $  1759-1760   @; label N12_1699	='1699_Subsq RX 3rd--Reg LN Rem';
input N12_1692 $  1761-1761   @; label N12_1692	='1692_Subsq RX 3rd Course Rad';
input N12_1693 $  1762-1762   @; label N12_1693	='1693_Subsq RX 3rd Course Chemo';
input N12_1694 $  1763-1763   @; label N12_1694	='1694_Subsq RX 3rd Course Horm';
input N12_1695 $  1764-1764   @; label N12_1695	='1695_Subsq RX 3rd Course BRM';
input N12_1696 $  1765-1765   @; label N12_1696	='1696_Subsq RX 3rd Course Oth';
input N12_1700 $  1766-1773   @; label N12_1700	='1700_Subsq RX 4th Course Date';
input N12_1701 $  1774-1775   @; label N12_1701	='1701_Subsq RX 4thCrs Date Flag';
input N12_1710 $  1776-1786   @; label N12_1710	='1710_Subsq RX 4th Course Codes';
input N12_1711 $  1776-1777   @; label N12_1711	='1711_Subsq RX 4th Course Surg';
input N12_1717 $  1778-1778   @; label N12_1717	='1717_Subsq RX 4th--Scope LN Su';
input N12_1718 $  1779-1779   @; label N12_1718	='1718_Subsq RX 4th--Surg Oth';
input N12_1719 $  1780-1781   @; label N12_1719	='1719_Subsq RX 4th--Reg LN Rem';
input N12_1712 $  1782-1782   @; label N12_1712	='1712_Subsq RX 4th Course Rad';
input N12_1713 $  1783-1783   @; label N12_1713	='1713_Subsq RX 4th Course Chemo';
input N12_1714 $  1784-1784   @; label N12_1714	='1714_Subsq RX 4th Course Horm';
input N12_1715 $  1785-1785   @; label N12_1715	='1715_Subsq RX 4th Course BRM';
input N12_1716 $  1786-1786   @; label N12_1716	='1716_Subsq RX 4th Course Oth';
input N12_1741 $  1787-1787   @; label N12_1741	='1741_Subsq RX--Reconstruct Del';
input N12_1300 $  1788-1887   @; label N12_1300	='1300_Reserved 07';
input N12_1981 $  1888-1888   @; label N12_1981	='1981_Over-ride SS/NodesPos';
input N12_1982 $  1889-1889   @; label N12_1982	='1982_Over-ride SS/TNM-N';
input N12_1983 $  1890-1890   @; label N12_1983	='1983_Over-ride SS/TNM-M';
input N12_1985 $  1891-1891   @; label N12_1985	='1985_Over-ride Acsn/Class/Seq';
input N12_1986 $  1892-1892   @; label N12_1986	='1986_Over-ride HospSeq/DxConf';
input N12_1987 $  1893-1893   @; label N12_1987	='1987_Over-ride CoC-Site/Type';
input N12_1988 $  1894-1894   @; label N12_1988	='1988_Over-ride HospSeq/Site';
input N12_1989 $  1895-1895   @; label N12_1989	='1989_Over-ride Site/TNM-StgGrp';
input N12_1990 $  1896-1896   @; label N12_1990	='1990_Over-ride Age/Site/Morph';
input N12_2000 $  1897-1897   @; label N12_2000	='2000_Over-ride SeqNo/DxConf';
input N12_2010 $  1898-1898   @; label N12_2010	='2010_Over-ride Site/Lat/SeqNo';
input N12_2020 $  1899-1899   @; label N12_2020	='2020_Over-ride Surg/DxConf';
input N12_2030 $  1900-1900   @; label N12_2030	='2030_Over-ride Site/Type';
input N12_2040 $  1901-1901   @; label N12_2040	='2040_Over-ride Histology';
input N12_2050 $  1902-1902   @; label N12_2050	='2050_Over-ride Report Source';
input N12_2060 $  1903-1903   @; label N12_2060	='2060_Over-ride Ill-define Site';
input N12_2070 $  1904-1904   @; label N12_2070	='2070_Over-ride Leuk, Lymphoma';
input N12_2071 $  1905-1905   @; label N12_2071	='2071_Over-ride Site/Behavior';
input N12_2072 $  1906-1906   @; label N12_2072	='2072_Over-ride Site/EOD/DX Dt';
input N12_2073 $  1907-1907   @; label N12_2073	='2073_Over-ride Site/Lat/EOD';
input N12_2074 $  1908-1908   @; label N12_2074	='2074_Over-ride Site/Lat/Morph';
input N12_1960 $  1909-1912   @; label N12_1960	='1960_Site (73-91) ICD-O-1';
input N12_1970 $  1913-1918   @; label N12_1970	='1970_Morph (73-91) ICD-O-1';
input N12_1971 $  1913-1916   @; label N12_1971	='1971_Histology (73-91) ICD-O-1';
input N12_1972 $  1917-1917   @; label N12_1972	='1972_Behavior (73-91) ICD-O-1';
input N12_1973 $  1918-1918   @; label N12_1973	='1973_Grade (73-91) ICD-O-1';
input N12_1980 $  1919-1919   @; label N12_1980	='1980_ICD-O-2 Conversion Flag';
input N12_2081 $  1920-1929   @; label N12_2081	='2081_CRC CHECKSUM';
input N12_2120 $  1930-1930   @; label N12_2120	='2120_SEER Coding Sys--Current';
input N12_2130 $  1931-1931   @; label N12_2130	='2130_SEER Coding Sys--Original';
input N12_2140 $  1932-1933   @; label N12_2140	='2140_CoC Coding Sys--Current';
input N12_2150 $  1934-1935   @; label N12_2150	='2150_CoC Coding Sys--Original';
input N12_2170 $  1936-1945   @; label N12_2170	='2170_Vendor Name';
input N12_2180 $  1946-1946   @; label N12_2180	='2180_SEER Type of Follow-Up';
input N12_2190 $  1947-1948   @; label N12_2190	='2190_SEER Record Number';
input N12_2200 $  1949-1950   @; label N12_2200	='2200_Diagnostic Proc 73-87';
input N12_2085 $  1951-1958   @; label N12_2085	='2085_Date Case Initiated';
input N12_2090 $  1959-1966   @; label N12_2090	='2090_Date Case Completed';
input N12_2092 $  1967-1974   @; label N12_2092	='2092_Date Case Completed--CoC';
input N12_2100 $  1975-1982   @; label N12_2100	='2100_Date Case Last Changed';
input N12_2110 $  1983-1990   @; label N12_2110	='2110_Date Case Report Exported';
input N12_2111 $  1991-1998   @; label N12_2111	='2111_Date Case Report Received';
input N12_2112 $  1999-2006   @; label N12_2112	='2112_Date Case Report Loaded';
input N12_2113 $  2007-2014   @; label N12_2113	='2113_Date Tumor Record Availbl';
input N12_2116 $  2015-2015   @; label N12_2116	='2116_ICD-O-3 Conversion Flag';
input N12_3750 $  2016-2016   @; label N12_3750	='3750_Over-ride CS 1';
input N12_3751 $  2017-2017   @; label N12_3751	='3751_Over-ride CS 2';
input N12_3752 $  2018-2018   @; label N12_3752	='3752_Over-ride CS 3';
input N12_3753 $  2019-2019   @; label N12_3753	='3753_Over-ride CS 4';
input N12_3754 $  2020-2020   @; label N12_3754	='3754_Over-ride CS 5';
input N12_3755 $  2021-2021   @; label N12_3755	='3755_Over-ride CS 6';
input N12_3756 $  2022-2022   @; label N12_3756	='3756_Over-ride CS 7';
input N12_3757 $  2023-2023   @; label N12_3757	='3757_Over-ride CS 8';
input N12_3758 $  2024-2024   @; label N12_3758	='3758_Over-ride CS 9';
input N12_3759 $  2025-2025   @; label N12_3759	='3759_Over-ride CS 10';
input N12_3760 $  2026-2026   @; label N12_3760	='3760_Over-ride CS 11';
input N12_3761 $  2027-2027   @; label N12_3761	='3761_Over-ride CS 12';
input N12_3762 $  2028-2028   @; label N12_3762	='3762_Over-ride CS 13';
input N12_3763 $  2029-2029   @; label N12_3763	='3763_Over-ride CS 14';
input N12_3764 $  2030-2030   @; label N12_3764	='3764_Over-ride CS 15';
input N12_3765 $  2031-2031   @; label N12_3765	='3765_Over-ride CS 16';
input N12_3766 $  2032-2032   @; label N12_3766	='3766_Over-ride CS 17';
input N12_3767 $  2033-2033   @; label N12_3767	='3767_Over-ride CS 18';
input N12_3768 $  2034-2034   @; label N12_3768	='3768_Over-ride CS 19';
input N12_3769 $  2035-2035   @; label N12_3769	='3769_Over-ride CS 20';
input N12_1650 $  2036-2115   @; label N12_1650	='1650_Reserved 08';
input N12_1750 $  2116-2123   @; label N12_1750	='1750_Date of Last Contact';
input N12_1751 $  2124-2125   @; label N12_1751	='1751_Date of Last Contact Flag';
input N12_1760 $  2126-2126   @; label N12_1760	='1760_Vital Status';
input N12_1770 $  2127-2127   @; label N12_1770	='1770_Cancer Status';
input N12_1780 $  2128-2128   @; label N12_1780	='1780_Quality of Survival';
input N12_1790 $  2129-2129   @; label N12_1790	='1790_Follow-Up Source';
input N12_1800 $  2130-2130   @; label N12_1800	='1800_Next Follow-Up Source';
input N12_1810 $  2131-2180   @; label N12_1810	='1810_Addr Current--City';
input N12_1820 $  2181-2182   @; label N12_1820	='1820_Addr Current--State';
input N12_1830 $  2183-2191   @; label N12_1830	='1830_Addr Current--Postal Code';
input N12_1840 $  2192-2194   @; label N12_1840	='1840_County--Current';
input N12_1850 $  2195-2195   @; label N12_1850	='1850_Unusual Follow-Up Method';
input N12_1860 $  2196-2203   @; label N12_1860	='1860_Recurrence Date--1st';
input N12_1861 $  2204-2205   @; label N12_1861	='1861_Recurrence Date--1st Flag';
input N12_1880 $  2206-2207   @; label N12_1880	='1880_Recurrence Type--1st';
input N12_1842 $  2208-2257   @; label N12_1842	='1842_Follow-Up Contact--City';
input N12_1844 $  2258-2259   @; label N12_1844	='1844_Follow-Up Contact--State';
input N12_1846 $  2260-2268   @; label N12_1846	='1846_Follow-Up Contact--Postal';
input N12_1910 $  2269-2272   @; label N12_1910	='1910_Cause of Death';
input N12_1920 $  2273-2273   @; label N12_1920	='1920_ICD Revision Number';
input N12_1930 $  2274-2274   @; label N12_1930	='1930_Autopsy';
input N12_1940 $  2275-2277   @; label N12_1940	='1940_Place of Death';
input N12_1791 $  2278-2279   @; label N12_1791	='1791_Follow-up Source Central';
input N12_1755 $  2280-2287   @; label N12_1755	='1755_Date of Death--Canada';
input N12_1756 $  2288-2289   @; label N12_1756	='1756_Date of Death--CanadaFlag';
input N12_1740 $  2290-2339   @; label N12_1740	='1740_Reserved 09';
input N12_2220 $  2340-3339   @; label N12_2220	='2220_State/Requestor Items';
				_
				_
input N12_2230 $  3340-3379   @; label N12_2230	='2230_Name--Last';
input N12_2240 $  3380-3419   @; label N12_2240	='2240_Name--First';
input N12_2250 $  3420-3459   @; label N12_2250	='2250_Name--Middle';
input N12_2260 $  3460-3462   @; label N12_2260	='2260_Name--Prefix';
input N12_2270 $  3463-3465   @; label N12_2270	='2270_Name--Suffix';
input N12_2280 $  3466-3505   @; label N12_2280	='2280_Name--Alias';
input N12_2390 $  3506-3545   @; label N12_2390	='2390_Name--Maiden';
input N12_2290 $  3546-3605   @; label N12_2290	='2290_Name--Spouse/Parent';
input N12_2300 $  3606-3616   @; label N12_2300	='2300_Medical Record Number';
input N12_2310 $  3617-3618   @; label N12_2310	='2310_Military Record No Suffix';
input N12_2320 $  3619-3627   @; label N12_2320	='2320_Social Security Number';
input N12_2330 $  3628-3687   @; label N12_2330	='2330_Addr at DX--No & Street';
input N12_2335 $  3688-3747   @; label N12_2335	='2335_Addr at DX--Supplementl';
input N12_2350 $  3748-3807   @; label N12_2350	='2350_Addr Current--No & Street';
input N12_2355 $  3808-3867   @; label N12_2355	='2355_Addr Current--Supplementl';
input N12_2360 $  3868-3877   @; label N12_2360	='2360_Telephone';
input N12_2380 $  3878-3883   @; label N12_2380	='2380_DC State File Number';
input N12_2394 $  3884-3943   @; label N12_2394	='2394_Follow-Up Contact--Name';
input N12_2392 $  3944-4003   @; label N12_2392	='2392_Follow-Up Contact--No&St';
input N12_2393 $  4004-4063   @; label N12_2393	='2393_Follow-Up Contact--Suppl';
input N12_2352 $  4064-4073   @; label N12_2352	='2352_Latitude';
input N12_2354 $  4074-4084   @; label N12_2354	='2354_Longitude';
input N12_1835 $  4085-4284   @; label N12_1835	='1835_Reserved 10';
input N12_2445 $  4285-4294   @; label N12_2445	='2445_NPI--Following Registry';
input N12_2440 $  4295-4304   @; label N12_2440	='2440_Following Registry';
input N12_2415 $  4305-4314   @; label N12_2415	='2415_NPI--Inst Referred From';
input N12_2410 $  4315-4324   @; label N12_2410	='2410_Institution Referred From';
input N12_2425 $  4325-4334   @; label N12_2425	='2425_NPI--Inst Referred To';
input N12_2420 $  4335-4344   @; label N12_2420	='2420_Institution Referred To';
input N12_1900 $  4345-4394   @; label N12_1900	='1900_Reserved 11';
input N12_2465 $  4395-4404   @; label N12_2465	='2465_NPI--Physician--Managing';
input N12_2460 $  4405-4412   @; label N12_2460	='2460_Physician--Managing';
input N12_2475 $  4413-4422   @; label N12_2475	='2475_NPI--Physician--Follow-Up';
input N12_2470 $  4423-4430   @; label N12_2470	='2470_Physician--Follow-Up';
input N12_2485 $  4431-4440   @; label N12_2485	='2485_NPI--Physician--Primary Surg';
input N12_2480 $  4441-4448   @; label N12_2480	='2480_Physician--Primary Surg';
input N12_2495 $  4449-4458   @; label N12_2495	='2495_NPI--Physician 3';
input N12_2490 $  4459-4466   @; label N12_2490	='2490_Physician 3';
input N12_2505 $  4467-4476   @; label N12_2505	='2505_NPI--Physician 4';
input N12_2500 $  4477-4484   @; label N12_2500	='2500_Physician 4';
input N12_2510 $  4485-4534   @; label N12_2510	='2510_Reserved 12';
input N12_7010 $  4535-4559   @; label N12_7010	='7010_Path Reporting Fac ID 1';
input N12_7090 $  4560-4579   @; label N12_7090	='7090_Path Report Number 1';
input N12_7320 $  4580-4593   @; label N12_7320	='7320_Path Date Spec Collect 1';
input N12_7480 $  4594-4595   @; label N12_7480	='7480_Path Report Type 1';
input N12_7190 $  4596-4620   @; label N12_7190	='7190_Path Ordering Fac No 1';
input N12_7100 $  4621-4640   @; label N12_7100	='7100_Path Order Phys Lic No 1';
input N12_7011 $  4641-4665   @; label N12_7011	='7011_Path Reporting Fac ID 2';
input N12_7091 $  4666-4685   @; label N12_7091	='7091_Path Report Number 2';
input N12_7321 $  4686-4699   @; label N12_7321	='7321_Path Date Spec Collect 2';
input N12_7481 $  4700-4701   @; label N12_7481	='7481_Path Report Type 2';
input N12_7191 $  4702-4726   @; label N12_7191	='7191_Path Ordering Fac No 2';
input N12_7101 $  4727-4746   @; label N12_7101	='7101_Path Order Phys Lic No 2';
input N12_7012 $  4747-4771   @; label N12_7012	='7012_Path Reporting Fac ID 3';
input N12_7092 $  4772-4791   @; label N12_7092	='7092_Path Report Number 3';
input N12_7322 $  4792-4805   @; label N12_7322	='7322_Path Date Spec Collect 3';
input N12_7482 $  4806-4807   @; label N12_7482	='7482_Path Report Type 3';
input N12_7192 $  4808-4832   @; label N12_7192	='7192_Path Ordering Fac No 3';
input N12_7102 $  4833-4852   @; label N12_7102	='7102_Path Order Phys Lic No 3';
input N12_7013 $  4853-4877   @; label N12_7013	='7013_Path Reporting Fac ID 4';
input N12_7093 $  4878-4897   @; label N12_7093	='7093_Path Report Number 4';
input N12_7323 $  4898-4911   @; label N12_7323	='7323_Path Date Spec Collect 4';
input N12_7483 $  4912-4913   @; label N12_7483	='7483_Path Report Type 4';
input N12_7193 $  4914-4938   @; label N12_7193	='7193_Path Ordering Fac No 4';
input N12_7103 $  4939-4958   @; label N12_7103	='7103_Path Order Phys Lic No 4';
input N12_7014 $  4959-4983   @; label N12_7014	='7014_Path Reporting Fac ID 5';
input N12_7094 $  4984-5003   @; label N12_7094	='7094_Path Report Number 5';
input N12_7324 $  5004-5017   @; label N12_7324	='7324_Path Date Spec Collect 5';
input N12_7484 $  5018-5019   @; label N12_7484	='7484_Path Report Type 5';
input N12_7194 $  5020-5044   @; label N12_7194	='7194_Path Ordering Fac No 5';
input N12_7104 $  5045-5064   @; label N12_7104	='7104_Path Order Phys Lic No 5';
input N12_2080 $  5065-5564   @; label N12_2080	='2080_Reserved 13';
				_
				_
input N12_2520 $  5565-6564   @; label N12_2520	='2520_Text--DX Proc--PE';
input N12_2530 $  6565-7564   @; label N12_2530	='2530_Text--DX Proc--X-ray/Scan';
input N12_2540 $  7565-8564   @; label N12_2540	='2540_Text--DX Proc--Scopes';
input N12_2550 $  8565-9564   @; label N12_2550	='2550_Text--DX Proc--Lab Tests';
input N12_2560 $  9565-10564  @; label N12_2560	='2560_Text--DX Proc--Op';
input N12_2570 $  10565-11564 @; label N12_2570	='2570_Text--DX Proc--Path';
input N12_2580 $  11565-11664 @; label N12_2580	='2580_Text--Primary Site Title';
input N12_2590 $  11665-11764 @; label N12_2590	='2590_Text--Histology Title';
input N12_2600 $  11765-12764 @; label N12_2600	='2600_Text--Staging';
input N12_2610 $  12765-13764 @; label N12_2610	='2610_RX Text--Surgery';
input N12_2620 $  13765-14764 @; label N12_2620	='2620_RX Text--Radiation (Beam)';
input N12_2630 $  14765-15764 @; label N12_2630	='2630_RX Text--Radiation Other';
input N12_2640 $  15765-16764 @; label N12_2640	='2640_RX Text--Chemo';
input N12_2650 $  16765-17764 @; label N12_2650	='2650_RX Text--Hormone';
input N12_2660 $  17765-18764 @; label N12_2660	='2660_RX Text--BRM';
input N12_2670 $  18765-19764 @; label N12_2670	='2670_RX Text--Other';
input N12_2680 $  19765-20764 @; label N12_2680	='2680_Text--Remarks';
input N12_2690 $  20765-20824 @; label N12_2690	='2690_Text--Place of Diagnosis';
input N12_2210 $  20825-22824 @; label N12_2210	='2210_Reserved 14';

/* ADDITIONAL RMCDS VARIABLES IN RECORD */
input   masterfn   $3332-3339   @;  label  masterfn  ='RMCDS MASTER FILE NUMBER';
input   NPAIHBlink $2350-2350   @;  label  NPAIHBlink='NPAIHB 1=Yes';

/* ADDITIONAL USEFUL VARIABLES IN RECORD */
input   dx_year    $530-533     @;  label  dx_year   ='YEAR OF DIAGNOSIS';
input   ZIPCode    $147-151     @;  label  ZIPCode   ='ZIP CODE 5-DIGIT';  
*/						




run;

data _NULL_;
   set V12;
*  file outV12 lrecl= 3339 pad; /* INCIDENCE */
   file outV12 lrecl= 5564 pad; /* CONFIDENTIAL */
*  file outV12 lrecl=22824 pad; /* TEXT */
put 
@  1     N12_10   $1.
@  2     N12_30   $1.
@  3     N12_35   $1.
@  4     N12_37   $13.
@  17    N12_50   $3.
@  20    N12_45   $10.
@  30    N12_40   $10.
@  40    N12_60   $2.
@  42    N12_20   $8.
@  50    N12_21   $8.
@  58    N12_370  $37.
@  95    N12_70   $50.
@  145   N12_80   $2.
@  147   N12_100  $9.
@  156   N12_90   $3.
@  159   N12_110  $6.
@  165   N12_368  $1.
@  166   N12_120  $1.
@  167   N12_364  $1.
@  168   N12_130  $6.
@  174   N12_362  $1.
@  175   N12_365  $1.
@  176   N12_150  $1.
@  177   N12_160  $2.
@  179   N12_161  $2.
@  181   N12_162  $2.
@  183   N12_163  $2.
@  185   N12_164  $2.
@  187   N12_170  $1.
@  188   N12_180  $1.
@  189   N12_190  $1.
@  190   N12_200  $1.
@  191   N12_210  $1.
@  192   N12_220  $1.
@  193   N12_230  $3.
@  196   N12_240  $8.
@  204   N12_241  $2.
@  206   N12_250  $3.
@  209   N12_270  $3.
@  212   N12_280  $3.
@  215   N12_290  $1.
@  216   N12_300  $1.
@  217   N12_310  $100.
@  317   N12_320  $100.
@  417   N12_330  $1.
@  418   N12_191  $1.
@  419   N12_193  $2.
@  421   N12_192  $1.
@  422   N12_366  $2.
@  424   N12_3300 $2.
@  426   N12_3310 $2.
@  428   N12_135  $6.
@  434   N12_363  $1.
@  435   N12_367  $1.
@  436   N12_530  $92.
@  528   N12_380  $2.
@  530   N12_390  $8.
@  538   N12_391  $2.
@  540   N12_400  $4.
@  544   N12_410  $1.
@  545   N12_419  $5.
@  545   N12_420  $4.
@  549   N12_430  $1.
@  550   N12_521  $5.
@  550   N12_522  $4.
@  554   N12_523  $1.
@  555   N12_440  $1.
@  556   N12_441  $1.
@  557   N12_449  $1.
@  558   N12_450  $1.
@  559   N12_460  $1.
@  560   N12_470  $1.
@  561   N12_480  $1.
@  562   N12_490  $1.
@  563   N12_500  $1.
@  564   N12_501  $2.
@  566   N12_442  $1.
@  567   N12_443  $8.
@  575   N12_448  $2.
@  577   N12_444  $2.
@  579   N12_445  $8.
@  587   N12_439  $2.
@  589   N12_446  $2.
@  591   N12_680  $100.
@  691   N12_545  $10.
@  701   N12_540  $10.
@  711   N12_3105 $10.
@  721   N12_3100 $10.
@  731   N12_550  $9.
@  740   N12_560  $2.
@  742   N12_570  $3.
@  745   N12_580  $8.
@  753   N12_581  $2.
@  755   N12_590  $8.
@  763   N12_591  $2.
@  765   N12_600  $8.
@  773   N12_601  $2.
@  775   N12_605  $1.
@  776   N12_610  $2.
@  778   N12_630  $2.
@  780   N12_2400 $1.
@  781   N12_668  $1.
@  782   N12_670  $2.
@  784   N12_672  $1.
@  785   N12_674  $1.
@  786   N12_676  $2.
@  788   N12_2450 $1.
@  789   N12_690  $1.
@  790   N12_700  $2.
@  792   N12_710  $2.
@  794   N12_720  $2.
@  796   N12_730  $1.
@  797   N12_740  $2.
@  799   N12_3280 $1.
@  800   N12_746  $2.
@  802   N12_747  $1.
@  803   N12_748  $1.
@  804   N12_750  $100.
@  904   N12_759  $1.
@  905   N12_760  $1.
@  906   N12_779  $12.
@  906   N12_780  $3.
@  909   N12_790  $2.
@  911   N12_800  $2.
@  913   N12_810  $1.
@  914   N12_820  $2.
@  916   N12_830  $2.
@  918   N12_840  $13.
@  931   N12_850  $2.
@  933   N12_860  $4.
@  937   N12_870  $1.
@  938   N12_1060 $2.
@  940   N12_880  $4.
@  944   N12_890  $4.
@  948   N12_900  $4.
@  952   N12_910  $4.
@  956   N12_920  $1.
@  957   N12_930  $1.
@  958   N12_940  $4.
@  962   N12_950  $4.
@  966   N12_960  $4.
@  970   N12_970  $4.
@  974   N12_980  $1.
@  975   N12_990  $1.
@  976   N12_1120 $2.
@  978   N12_1130 $2.
@  980   N12_1140 $1.
@  981   N12_1150 $1.
@  982   N12_1160 $1.
@  983   N12_1170 $1.
@  984   N12_1182 $1.
@  985   N12_2800 $3.
@  988   N12_2810 $3.
@  991   N12_2820 $1.
@  992   N12_2830 $3.
@  995   N12_2840 $1.
@  996   N12_2850 $2.
@  998   N12_2860 $1.
@  999   N12_2851 $1.
@  1000  N12_2852 $1.
@  1001  N12_2853 $1.
@  1002  N12_2854 $1.
@  1003  N12_2880 $3.
@  1006  N12_2890 $3.
@  1009  N12_2900 $3.
@  1012  N12_2910 $3.
@  1015  N12_2920 $3.
@  1018  N12_2930 $3.
@  1021  N12_2861 $3.
@  1024  N12_2862 $3.
@  1027  N12_2863 $3.
@  1030  N12_2864 $3.
@  1033  N12_2865 $3.
@  1036  N12_2866 $3.
@  1039  N12_2867 $3.
@  1042  N12_2868 $3.
@  1045  N12_2869 $3.
@  1048  N12_2870 $3.
@  1051  N12_2871 $3.
@  1054  N12_2872 $3.
@  1057  N12_2873 $3.
@  1060  N12_2874 $3.
@  1063  N12_2875 $3.
@  1066  N12_2876 $3.
@  1069  N12_2877 $3.
@  1072  N12_2878 $3.
@  1075  N12_2879 $3.
@  1078  N12_2730 $3.
@  1081  N12_2735 $3.
@  1084  N12_2740 $1.
@  1085  N12_2750 $3.
@  1088  N12_2755 $1.
@  1089  N12_2760 $2.
@  1091  N12_2765 $1.
@  1092  N12_2770 $3.
@  1095  N12_2775 $3.
@  1098  N12_2780 $3.
@  1101  N12_2785 $2.
@  1103  N12_2940 $2.
@  1105  N12_2950 $1.
@  1106  N12_2960 $2.
@  1108  N12_2970 $1.
@  1109  N12_2980 $2.
@  1111  N12_2990 $1.
@  1112  N12_3000 $2.
@  1114  N12_3400 $3.
@  1117  N12_3402 $1.
@  1118  N12_3410 $3.
@  1121  N12_3412 $1.
@  1122  N12_3420 $3.
@  1125  N12_3422 $1.
@  1126  N12_3430 $3.
@  1129  N12_3440 $3.
@  1132  N12_3442 $1.
@  1133  N12_3450 $3.
@  1136  N12_3452 $1.
@  1137  N12_3460 $3.
@  1140  N12_3462 $1.
@  1141  N12_3470 $3.
@  1144  N12_3480 $3.
@  1147  N12_3482 $3.
@  1150  N12_3490 $2.
@  1152  N12_3492 $3.
@  1155  N12_3010 $1.
@  1156  N12_3020 $1.
@  1157  N12_3600 $1.
@  1158  N12_3030 $1.
@  1159  N12_3040 $1.
@  1160  N12_3050 $1.
@  1161  N12_2937 $6.
@  1167  N12_2935 $6.
@  1173  N12_2936 $6.
@  1179  N12_3700 $1.
@  1180  N12_3702 $1.
@  1181  N12_3704 $1.
@  1182  N12_3706 $1.
@  1183  N12_3708 $1.
@  1184  N12_3710 $1.
@  1185  N12_3165 $1.
@  1186  N12_3110 $5.
@  1191  N12_3120 $5.
@  1196  N12_3130 $5.
@  1201  N12_3140 $5.
@  1206  N12_3150 $5.
@  1211  N12_3160 $5.
@  1216  N12_3161 $5.
@  1221  N12_3162 $5.
@  1226  N12_3163 $5.
@  1231  N12_3164 $5.
@  1236  N12_1180 $200.
@  1436  N12_1260 $8.
@  1444  N12_1261 $2.
@  1446  N12_1270 $8.
@  1454  N12_1271 $2.
@  1456  N12_1200 $8.
@  1464  N12_1201 $2.
@  1466  N12_3170 $8.
@  1474  N12_3171 $2.
@  1476  N12_3180 $8.
@  1484  N12_3181 $2.
@  1486  N12_1210 $8.
@  1494  N12_1211 $2.
@  1496  N12_3220 $8.
@  1504  N12_3221 $2.
@  1506  N12_3230 $8.
@  1514  N12_3231 $2.
@  1516  N12_1220 $8.
@  1524  N12_1221 $2.
@  1526  N12_1230 $8.
@  1534  N12_1231 $2.
@  1536  N12_1240 $8.
@  1544  N12_1241 $2.
@  1546  N12_1250 $8.
@  1554  N12_1251 $2.
@  1556  N12_1280 $8.
@  1564  N12_1281 $2.
@  1566  N12_1285 $1.
@  1567  N12_1290 $2.
@  1569  N12_1292 $1.
@  1570  N12_1294 $1.
@  1571  N12_1296 $2.
@  1573  N12_1310 $1.
@  1574  N12_1320 $1.
@  1575  N12_1330 $1.
@  1576  N12_1340 $1.
@  1577  N12_1350 $2.
@  1579  N12_3270 $1.
@  1580  N12_1360 $1.
@  1581  N12_1370 $1.
@  1582  N12_1380 $1.
@  1583  N12_3250 $2.
@  1585  N12_1390 $2.
@  1587  N12_1400 $2.
@  1589  N12_1410 $2.
@  1591  N12_1420 $1.
@  1592  N12_1430 $1.
@  1593  N12_1460 $2.
@  1595  N12_1500 $1.
@  1596  N12_1510 $5.
@  1601  N12_1520 $3.
@  1604  N12_1540 $2.
@  1606  N12_1550 $1.
@  1607  N12_1570 $2.
@  1609  N12_3200 $2.
@  1611  N12_3210 $5.
@  1616  N12_1639 $1.
@  1617  N12_1640 $2.
@  1619  N12_3190 $1.
@  1620  N12_1646 $2.
@  1622  N12_1647 $1.
@  1623  N12_1648 $1.
@  1624  N12_1190 $100.
@  1724  N12_1660 $8.
@  1732  N12_1661 $2.
@  1734  N12_1670 $11.
@  1734  N12_1671 $2.
@  1736  N12_1677 $1.
@  1737  N12_1678 $1.
@  1738  N12_1679 $2.
@  1740  N12_1672 $1.
@  1741  N12_1673 $1.
@  1742  N12_1674 $1.
@  1743  N12_1675 $1.
@  1744  N12_1676 $1.
@  1745  N12_1680 $8.
@  1753  N12_1681 $2.
@  1755  N12_1690 $11.
@  1755  N12_1691 $2.
@  1757  N12_1697 $1.
@  1758  N12_1698 $1.
@  1759  N12_1699 $2.
@  1761  N12_1692 $1.
@  1762  N12_1693 $1.
@  1763  N12_1694 $1.
@  1764  N12_1695 $1.
@  1765  N12_1696 $1.
@  1766  N12_1700 $8.
@  1774  N12_1701 $2.
@  1776  N12_1710 $11.
@  1776  N12_1711 $2.
@  1778  N12_1717 $1.
@  1779  N12_1718 $1.
@  1780  N12_1719 $2.
@  1782  N12_1712 $1.
@  1783  N12_1713 $1.
@  1784  N12_1714 $1.
@  1785  N12_1715 $1.
@  1786  N12_1716 $1.
@  1787  N12_1741 $1.
@  1788  N12_1300 $100.
@  1888  N12_1981 $1.
@  1889  N12_1982 $1.
@  1890  N12_1983 $1.
@  1891  N12_1985 $1.
@  1892  N12_1986 $1.
@  1893  N12_1987 $1.
@  1894  N12_1988 $1.
@  1895  N12_1989 $1.
@  1896  N12_1990 $1.
@  1897  N12_2000 $1.
@  1898  N12_2010 $1.
@  1899  N12_2020 $1.
@  1900  N12_2030 $1.
@  1901  N12_2040 $1.
@  1902  N12_2050 $1.
@  1903  N12_2060 $1.
@  1904  N12_2070 $1.
@  1905  N12_2071 $1.
@  1906  N12_2072 $1.
@  1907  N12_2073 $1.
@  1908  N12_2074 $1.
@  1909  N12_1960 $4.
@  1913  N12_1970 $6.
@  1913  N12_1971 $4.
@  1917  N12_1972 $1.
@  1918  N12_1973 $1.
@  1919  N12_1980 $1.
@  1920  N12_2081 $10.
@  1930  N12_2120 $1.
@  1931  N12_2130 $1.
@  1932  N12_2140 $2.
@  1934  N12_2150 $2.
@  1936  N12_2170 $10.
@  1946  N12_2180 $1.
@  1947  N12_2190 $2.
@  1949  N12_2200 $2.
@  1951  N12_2085 $8.
@  1959  N12_2090 $8.
@  1967  N12_2092 $8.
@  1975  N12_2100 $8.
@  1983  N12_2110 $8.
@  1991  N12_2111 $8.
@  1999  N12_2112 $8.
@  2007  N12_2113 $8.
@  2015  N12_2116 $1.
@  2016  N12_3750 $1.
@  2017  N12_3751 $1.
@  2018  N12_3752 $1.
@  2019  N12_3753 $1.
@  2020  N12_3754 $1.
@  2021  N12_3755 $1.
@  2022  N12_3756 $1.
@  2023  N12_3757 $1.
@  2024  N12_3758 $1.
@  2025  N12_3759 $1.
@  2026  N12_3760 $1.
@  2027  N12_3761 $1.
@  2028  N12_3762 $1.
@  2029  N12_3763 $1.
@  2030  N12_3764 $1.
@  2031  N12_3765 $1.
@  2032  N12_3766 $1.
@  2033  N12_3767 $1.
@  2034  N12_3768 $1.
@  2035  N12_3769 $1.
@  2036  N12_1650 $80.
@  2116  N12_1750 $8.
@  2124  N12_1751 $2.
@  2126  N12_1760 $1.
@  2127  N12_1770 $1.
@  2128  N12_1780 $1.
@  2129  N12_1790 $1.
@  2130  N12_1800 $1.
@  2131  N12_1810 $50.
@  2181  N12_1820 $2.
@  2183  N12_1830 $9.
@  2192  N12_1840 $3.
@  2195  N12_1850 $1.
@  2196  N12_1860 $8.
@  2204  N12_1861 $2.
@  2206  N12_1880 $2.
@  2208  N12_1842 $50.
@  2258  N12_1844 $2.
@  2260  N12_1846 $9.
@  2269  N12_1910 $4.
@  2273  N12_1920 $1.
@  2274  N12_1930 $1.
@  2275  N12_1940 $3.
@  2278  N12_1791 $2.
@  2280  N12_1755 $8.
@  2288  N12_1756 $2.
@  2290  N12_1740 $50.
@  2340  N12_2220 $1000.

@  3340  N12_2230 $40.
@  3380  N12_2240 $40.
@  3420  N12_2250 $40.
@  3460  N12_2260 $3.
@  3463  N12_2270 $3.
@  3466  N12_2280 $40.
@  3506  N12_2390 $40.
@  3546  N12_2290 $60.
@  3606  N12_2300 $11.
@  3617  N12_2310 $2.
@  3619  N12_2320 $9.
@  3628  N12_2330 $60.
@  3688  N12_2335 $60.
@  3748  N12_2350 $60.
@  3808  N12_2355 $60.
@  3868  N12_2360 $10.
@  3878  N12_2380 $6.
@  3884  N12_2394 $60.
@  3944  N12_2392 $60.
@  4004  N12_2393 $60.
@  4064  N12_2352 $10.
@  4074  N12_2354 $11.
@  4085  N12_1835 $200.
@  4285  N12_2445 $10.
@  4295  N12_2440 $10.
@  4305  N12_2415 $10.
@  4315  N12_2410 $10.
@  4325  N12_2425 $10.
@  4335  N12_2420 $10.
@  4345  N12_1900 $50.
@  4395  N12_2465 $10.
@  4405  N12_2460 $8.
@  4413  N12_2475 $10.
@  4423  N12_2470 $8.
@  4431  N12_2485 $10.
@  4441  N12_2480 $8.
@  4449  N12_2495 $10.
@  4459  N12_2490 $8.
@  4467  N12_2505 $10.
@  4477  N12_2500 $8.
@  4485  N12_2510 $50.
@  4535  N12_7010 $25.
@  4560  N12_7090 $20.
@  4580  N12_7320 $14.
@  4594  N12_7480 $2.
@  4596  N12_7190 $25.
@  4621  N12_7100 $20.
@  4641  N12_7011 $25.
@  4666  N12_7091 $20.
@  4686  N12_7321 $14.
@  4700  N12_7481 $2.
@  4702  N12_7191 $25.
@  4727  N12_7101 $20.
@  4747  N12_7012 $25.
@  4772  N12_7092 $20.
@  4792  N12_7322 $14.
@  4806  N12_7482 $2.
@  4808  N12_7192 $25.
@  4833  N12_7102 $20.
@  4853  N12_7013 $25.
@  4878  N12_7093 $20.
@  4898  N12_7323 $14.
@  4912  N12_7483 $2.
@  4914  N12_7193 $25.
@  4939  N12_7103 $20.
@  4959  N12_7014 $25.
@  4984  N12_7094 $20.
@  5004  N12_7324 $14.
@  5018  N12_7484 $2.
@  5020  N12_7194 $25.
@  5045  N12_7104 $20.
@  5065  N12_2080 $500.

/*
@  5565  N12_2520 $1000.
@  6565  N12_2530 $1000.
@  7565  N12_2540 $1000.
@  8565  N12_2550 $1000.
@  9565  N12_2560 $1000.
@  10565 N12_2570 $1000.
@  11565 N12_2580 $100.
@  11665 N12_2590 $100.
@  11765 N12_2600 $1000.
@  12765 N12_2610 $1000.
@  13765 N12_2620 $1000.
@  14765 N12_2630 $1000.
@  15765 N12_2640 $1000.
@  16765 N12_2650 $1000.
@  17765 N12_2660 $1000.
@  18765 N12_2670 $1000.
@  19765 N12_2680 $1000.
@  20765 N12_2690 $60.
@  20825 N12_2210 $2000.
*/

@   3332 masterfn   $8.
@   2350 NPAIHBlink $1.

;
run;
