/* jenner-check: extracted from "Anonymize and Mask Data.step" (a SAS
   Studio custom step) which embeds this locale-resolution macro ahead
   of a %DQLOAD / dqStandardize() masking call. The DQ Server functions
   are a licensed DataFlux/Quality Knowledge Base add-on Jenner doesn't
   (and can't reasonably) provide sample data for, so this bundle keeps
   just the self-contained %setLoc macro -- unmodified -- and adds a
   small caller loop that exercises its full branch table. */
%macro setLoc(selectedLocale);
%global QKBlocale;
%global Compressedlocale;

%let Compressedlocale = %sysfunc(compress(&selectedLocale," -"));

	%if &Compressedlocale = AfrikaansSouthAfrica %then %let QKBlocale = AFZAF;
	%else %if &Compressedlocale = ArabicEgypt %then %let QKBlocale = AREGY;
	%else %if &Compressedlocale = ChineseChina %then %let QKBlocale = ZHCHN;
	%else %if &Compressedlocale = CzechCzechRepublic %then %let QKBlocale = CSCZE;
	%else %if &Compressedlocale = DanishDenmark %then %let QKBlocale = DADNK;
	%else %if &Compressedlocale = DutchBelguim %then %let QKBlocale = NLBEL;
	%else %if &Compressedlocale = DutchNetherlands %then %let QKBlocale = NLNLD;
	%else %if &Compressedlocale = EnglishAustralia %then %let QKBlocale = ENAUS;
	%else %if &Compressedlocale = EnglishCanada %then %let QKBlocale = ENCAN;
	%else %if &Compressedlocale = EnglishHongKong %then %let QKBlocale = ENHKG;
	%else %if &Compressedlocale = EnglishIndia %then %let QKBlocale = ENIND;
	%else %if &Compressedlocale = EnglishNewZealand %then %let QKBlocale = ENNZL;
	%else %if &Compressedlocale = EnglishPhilippines %then %let QKBlocale = ENPHL;
	%else %if &Compressedlocale = EnglishSingapore %then %let QKBlocale = ENSIN;
 	%else %if &Compressedlocale = EnglishSouthAfrica %then %let QKBlocale = ENZAF;	
 	%else %if &Compressedlocale = EnglishUnitedKingdom %then %let QKBlocale = ENGBR;
 	%else %if &Compressedlocale = EnglishUnitedStates %then %let QKBlocale = ENUSA;
	%else %if &Compressedlocale = FinnishFinland %then %let QKBlocale = FIFIN;
	%else %if &Compressedlocale = FrenchBelguim %then %let QKBlocale = FRBEL;
	%else %if &Compressedlocale = FrenchCanada %then %let QKBlocale = FRCAN;
	%else %if &Compressedlocale = FrenchFrance %then %let QKBlocale = FRFRA;
	%else %if &Compressedlocale = GermanGermany %then %let QKBlocale = DEDEU;
	%else %if &Compressedlocale = GreekGreece %then %let QKBlocale = ELGRC;
	%else %if &Compressedlocale = HebrewIsrael %then %let QKBlocale = HEISR;
	%else %if &Compressedlocale = HungarianHungary %then %let QKBlocale = HUHUN;
	%else %if &Compressedlocale = ItalianItaly %then %let QKBlocale = ITITA;
	%else %if &Compressedlocale = JapaneseJapan %then %let QKBlocale = JAJPN;
	%else %if &Compressedlocale = KoreanSouthKorea %then %let QKBlocale = KOKOR;
	%else %if &Compressedlocale = MalayMalaysia %then %let QKBlocale = MSMYS;
	%else %if &Compressedlocale = NorwegianNorway %then %let QKBlocale = NONOR;
 	%else %if &Compressedlocale = PolishPoland %then %let QKBlocale = PLPOL;	
 	%else %if &Compressedlocale = PortugueseBrazil %then %let QKBlocale = PTBRA;
 	%else %if &Compressedlocale = PortuguesePortugal %then %let QKBlocale = PTPRT;
	%else %if &Compressedlocale = RomanianRomania %then %let QKBlocale = ROROU;
	%else %if &Compressedlocale = RussianRussia %then %let QKBlocale = RURUS;
	%else %if &Compressedlocale = SlovakSlovakia %then %let QKBlocale = SKSVK;
	%else %if &Compressedlocale = SlovenianSlovenia %then %let QKBlocale = SLSVN;
	%else %if &Compressedlocale = SpanishArgentina %then %let QKBlocale = ESARG;
	%else %if &Compressedlocale = SpanishMexico %then %let QKBlocale = ESMEX;
	%else %if &Compressedlocale = SpanishSpain %then %let QKBlocale = ESESP;
 	%else %if &Compressedlocale = SwedishSweden %then %let QKBlocale = SVSWE;	
 	%else %if &Compressedlocale = ThaiThailand %then %let QKBlocale = THTHA;
 	%else %if &Compressedlocale = TurkishTurkey %then %let QKBlocale = TRTUR;
	%else %let QKBlocale = ENUSA;

%mend;

/* caller: exercise a representative spread of the branch table plus
   the ENUSA fallback branch */
data _null_;
  length locale $30;
  input locale $ 1-30;
  call symputx('loc'||left(_n_), locale);
  datalines;
English United States
French France
Chinese China
Japanese Japan
Klingon Qonos
;
run;

%macro runLoc(n);
  %setLoc(&&loc&n);
  %put NOTE: locale=&&loc&n resolved QKBlocale=&QKBlocale;
%mend;

%runLoc(1)
%runLoc(2)
%runLoc(3)
%runLoc(4)
%runLoc(5)
