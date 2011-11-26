#Klaipada
update locations
set alternate_names =  'Klp,KLP,klp,Klaipėdą,Klaipėdos,Klaipedos,KlaipĖda,KlaipĖdĄ,' || alternate_names
where id = 598098
and country_code = 'LT'

#Vilnius
update locations
set alternate_names = 'VLN,Vln,vln,Vilniaus,Vilniu,Vilnių,' || alternate_names
where id = 593116
and country_code = 'LT'

#Panevezys
update locations
set alternate_names = 'Pnv,PNV,pnv,PanevĖŽys,' || alternate_names
where id = 596128
and country_code = 'LT'

#Kaunas
update locations
set alternate_names = 'kauna,Kauną,Kns,KNS,kns,' || alternate_names
where id = 598316
and country_code = 'LT'

--** ORIGINAL ALTERNATE NAMES **--
#Klaipada
update locations
set alternate_names = 'Klaipada,Klaipeda,Klaipenta,Klaipéda,Klaipēda,Klaipėda,Klajpeda,Klaypeda,Kłajpeda,Lungsod ng Klaipeda,Lungsod ng Klaipėda,Memel,Memela,ke lai pei da,keullaipeda,khil pheda,klaipedas,kuraipeda,qlypdh,qlyypdh,Κλαϊπέντα,Клаипеда,Клайпеда,Клајпеда,קלייפדה,קליפדה,ไคลเพดา,クライペダ,克莱佩达,클라이페다'
where id = 598098
and country_code = 'LT'

#Vilnius
update locations
set alternate_names = 'Bilna,Bilnious,VIL''NJUS,Vil''njus,Vil''no,Vil''nyus,Vilna,Vilnia,Vilnious,Vilnius,Vilnjus,Vilno,Vilnues,Vilnus,Vilnyus,Vilníus,Vilnüs,Viļņa,Vílnius,Wilna,Wilno,bilnyuseu,birinyusu,fylnyws,vilniusi,wei er niu si,wi lni xus,wylnh,wylnyws,Βίλνα,Βίλνιους,Βιλνιους,ВИЛЬНЮС,Вилнус,Вилнюс,Вильнюс,Виљнус,Виљњус,Вільнюс,Вільня,Վիլնյուս,וילנה,فيلنيوس,ویلنیوس,วิลนีอุส,ვილნიუსი,ቪልኒውስ,ビリニュス,维尔纽斯,빌뉴스'
where id = 593116
and country_code = 'LT'

#Panevezys
update locations
set alternate_names = 'PANEVEZHIS,Paneveza,Panevezhi,Panevezhis,Panevezio,Panevezys,Panevēža,Panevėžio,Panevėžys,Panjavezhis,Ponewesch,Poniewesch,Poniewiesh,Poniewiez,Poniewież,pnbz''ys,ПАНЕВЕЖИС,Паневежис,Панявежис'
where id = 596128
and country_code = 'LT'

#Kaunas
update locations
set alternate_names = 'Caunas,KAUNAS,Kauen,Kaunas,Kauno,Kovno,Kowno,Palemonas,КАУНАС,Каунас'
where id = 598316
and country_code = 'LT'

