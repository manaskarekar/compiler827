#########################################################################		                                                         ##
##			       MILESTONE 5: PRAGMATICS                      ##
##		  Manas Karekar   email: mkareka@clemson.edu             ##
##		Yashodhan Fadnavis email : yfadnav@clemson.edu           ##
##				                                             ## 
##	                    Mon Feb 25 15:08:27 2008                   ##
##                                                                   ##    ##                                                                   ##
##				                                             ##
#######################################################################

#!/usr/bin/perl -w
use strict;

open (TESTDATA, "proc.txt") or die "Cant read Test Data File $!";
my @lines =<TESTDATA>;
close (TESTDATA);
my $outputFile = "proc_op.txt";
my $fTuple = "procFourTuple.txt";
my $pragFTuple = "PragFourTuple.s";
my $match=0;     	### Setting the FLAG in case a match is found in the reserve word array. ###
my $comFlag=0;     ### Declaring the mulitiline comment flag ###
my $line;
my $endl;
my @flags = ();
printGrpDetail ();
my @outputLines = ();
my @ftupleOutput = ();
my @pragftuple = ();
my $TOTALFLAGS = 32;
my @inputString;
my $inputString;
my $ipStr;
my $stackTop;
my @stack = ("@");
my @inputStringCodesRev;
my @inputStringCodes;
my $inputStringCodesTop = "@";
initFlags ();
my $i; my $j; my $k;
my @spmatrix;
my @rows;
my $relation;
my @handle; 
my $handleTop;
my $plist;
my $redNum;
my $comePanic=0;
my $redFlag;
my $flagHLen;
my @temp;
my $bool = 0;

#my $redNum;



my @semStack;my $semStackTop; my $semStackIndex;
my @symTab;
my $symTab;
my $ptrSymTab;
my $semLen;
my $symTabLen;
my @localST;
my $localSTLen;
my $procFlag=0;
my $a;
my $varDecl;   #flag
my $equalFound;


# semantics2
my $irn=0;
my @iRTab;
my $type;
my $label=0;
my @labTab;
my $toChk;
my $iType;
my $jType;
my $len;
my $toPush;
my $notDecl = 0;
my $semVar;
my $yesBoole;
my @ftuple;
my $ftupleIndex;


#pragmatics
my @pragFTuple;
my $memStkIndex = 0;
my $beginFP = -16;
my @vectorsize;my @matrix;
my $memReq = 0;
my $prevMemVal;
my $newMemVal;
my $sp = -120;
my $memAlloc;
my $numParams =0;
my $fpOffset;
my $staticMemCount = 0;
my $count;
my $pragFlag= 0;
my @prevMem;
my $prevMemCount=0;
my @phyReg;
$i = 0;
while($i != 8)
{
    $phyReg[$i] = "-";
    $i++;
}
my @virReg;
$i = 0;
while($i != 8)
{
    $virReg[$i] = "-";
    $i++;
}
my @memStack;
my $memStackIndex=0;
my $currLoc = 0;
my $fpoffset = 4;
$memAlloc = $sp-$memReq;
my $PHYREGS = 8;
my %memStack = ();
my $numVirtReg = 4;
my $procName = "";
my $outRegNum = 0;
my %sizeMem;
my $fpoffset1;
my $pragproc = 0;
my $procCount;
my $finStart = 1;
my %procMemStack;



open (SPMATRIX, "spmatrix.txt")or die "Cant read Test Data File $!";
my @spmlines =<SPMATRIX>;


printFlags();

	    ######### Assigning codes #########

my %tokenCode = (							 
			'int' => 1,'real' => 2,
			'comment' => 3,'printFlag' => 4,
			'identifier' =>5,'reserved' => 6,
			'ASCII' => 7,'MultipleASCII' => 8.
		);

 my %reservedWords = (	'PROGRAM_END'=>9, 'IF_END'=>10, 'WHILE_END'=>11,
			'PROGRAM'=>12,'DECLARATION'=>5, 'DECLARATION_END'=>6,
			'REAL'=>7, 'INTEGER'=>8,'PROCEDURE'=>9,
			'PROCEDURE_END'=>10, 'VALUE'=>11, 'REFERENCE'=>12,
			'COMPUTE'=>13, 'COMPUTE_END'=>14, 'READ'=>15,
			'PRINT'=>16, 'EXECUTE'=>17,'ELSE'=>18,
			'IF'=>19, 'THEN'=>20, 'DO'=>21, 'WHILE'=>22
		      );

my %multiAscii = ('=='=>23,'!='=>24,'<='=>25,'>='=>26,'<-'=>27,'::'=>28);

my %ascii = (	']'=>29,'['=>30,'('=>31,')'=>32,':'=>33,'!'=>34,'>'=>35,'<'=>36,
		'+'=>37,'-'=>38,';'=>39,','=>40,'*'=>41,'/'=>42,'{'=>43,'}'=>44,
		'&'=>45,'|'=>46,'~'=>47
	     );

my %parseTokenCode = (
    
'start' =>1,
'prog' =>2,
'body' =>3,
'declpart' =>4,
'decllist' =>5,
'decllist-' =>6,
'declstat' =>7,
'declstat-' =>8,
'type' =>9,
'procpart' =>10,
'proclist' =>11,
'proc' =>12,
'prochead' =>13,
'procname' =>14,
'fparmlist' =>15,
'fparmlist-' =>16,
'callby' =>17,
'execpart' =>18,
'exechead' =>19,
'statlist' =>20,
'statlist-' =>21,
'stat' =>22,
'instat' =>23,
'instat-' =>24,
'outstat' =>25,
'outstat-' =>26,
'callstat' =>27,
'callname' =>28,
'aparmlist' =>29,
'aparmlist-' =>30,
'ifstat' =>31,
'ifthen' =>32,
'ifhead' =>33,
'whilestat' =>34,
'whiletest' =>35,
'whilehead' =>36,
'assignstat' =>37,
'astat-' =>38,
'bexpr' =>39,
'orexpr' =>40,
'andexpr' =>41,
'andexpr-' =>42,
'notexpr' =>43,
'relexpr' =>44,
'aexpr' =>45,
'aexpr-' =>46,
'term' =>47,
'term-' =>48,
'primary' =>49,
'PROGRAM_END' =>50,
'PROGRAM' =>51,
'DECLARATION' =>52,
'DECLARATION_END' =>53,
';' =>54,
',' =>55,
'var' =>56,
'integer' =>57,
'::' =>58,
'INTEGER' =>59,
'REAL' =>60,
'PROCEDURE_END' =>61,
'PROCEDURE' =>62,
'}' =>63,
'{' =>64,
'VALUE' =>65,
'REFERENCE' =>66,
'COMPUTE_END' =>67,
'COMPUTE' =>68,
'[' =>69,
']' =>70,
':' =>71,
'READ' =>72,
'PRINT' =>73,
'EXECUTE' =>74,
'IF_END' =>75,
'ELSE' =>76,
'IF' =>77,
'THEN' =>78,
'WHILE_END' =>79,
'DO' =>80,
'WHILE' =>81,
'<-' =>82,
'|' =>83,
'&' =>84,
'!' =>85,
'<' =>86,
'<=' =>87,
'>' =>88,
'>=' =>89,
'==' =>90,
'!=' =>91,
'+' =>92,
'-' =>93,
'*' =>94,
'/' =>95,
'(' =>96,
')' =>97,
'real' =>98.    
    
);
my @plist = (
    ["3","2","3","50","1"],
["1","51","2"],
["3","4","10","18","3"],
["2","4","18","3"],
["3","52","5","53","4"],
["1","6","5"],
["3","6","7","54","6"],
["2","7","54","6"],
["1","8","7"],
["3","8","55","56","8"],
["2","9","56","8"],
["3","9","57","56","8"],
["5","9","57","58","57","56","8"],
["1","59","9"],
["1","60","9"],
["1","11","10"],
["2","11","12","11"],
["1","12","11"],
["4","13","4","20","61","12"],
["3","13","20","61","12"],
["1","14","13"],
["2","14","15","13"],
["2","62","56","14"],
["2","16","63","15"],
["5","16","55","17","9","56","16"],
["6","16","55","17","9","57","56","16"],
["8","16","55","17","9","57","58","57","56","16"],
["4","64","17","9","56","16"],
["5","64","17","9","57","56","16"],
["7","64","17","9","57","58","57","56","16"],
["1","65","17"],
["1","66","17"],
["3","19","20","67","18"],
["1","68","19"],
["1","21","20"],
["2","21","22","21"],
["1","22","21"],
["2","34","54","22"],
["2","31","54","22"],
["2","37","54","22"],
["2","23","54","22"],
["2","25","54","22"],
["2","27","54","22"],
["1","24","23"],
["2","24","56","24"],
["5","24","56","69","45","70","24"],
["7","24","56","69","45","71","45","70","24"],
["2","72","56","24"],
["5","72","56","69","45","70","24"],
["7","72","56","69","45","71","45","70","24"],
["1","26","25"],
["2","26","56","26"],
["5","26","56","69","45","70","26"],
["7","26","56","69","45","71","45","70","26"],
["2","73","56","26"],
["5","73","56","69","45","70","26"],
["7","73","56","69","45","71","45","70","26"],
["1","28","27"],
["2","28","29","27"],
["2","74","56","28"],
["2","30","63","29"],
["4","30","55","17","56","30"],
["7","30","55","17","56","69","45","70","30"],
["9","30","55","17","56","69","45","71","45","70","30"],
["3","64","17","56","30"],
["6","64","17","56","69","45","70","30"],
["8","64","17","56","69","45","71","45","70","30"],
["3","33","20","75","31"],
["3","32","20","75","31"],
["3","33","20","76","32"],
["3","77","39","78","33"],
["3","35","20","79","34"],
["3","36","39","80","35"],
["1","81","36"],
["1","38","37"],
["3","56","82","45","38"],
["6","56","69","45","70","82","45","38"],
["8","56","69","45","71","45","70","82","45","38"],
["1","40","39"],
["3","40","83","41","40"],
["1","41","40"],
["1","42","41"],
["3","42","84","43","42"],
["1","43","42"],
["2","85","44","43"],
["1","44","43"],
["3","45","86","45","44"],
["3","45","87","45","44"],
["3","45","88","45","44"],
["3","45","89","45","44"],
["3","45","90","45","44"],
["3","45","91","45","44"],
["1","45","44"],
["1","46","45"],
["3","46","92","47","46"],
["3","46","93","47","46"],
["2","93","47","46"],
["1","47","46"],
["1","48","47"],
["3","48","94","49","48"],
["3","48","95","49","48"],
["1","49","48"],
["3","96","39","97","49"],
["1","57","49"],
["1","98","49"],
["1","56","49"],
["4","56","69","45","70","49"],
["6","56","69","45","71","45","70","49"]
    
    );


    for($i=0;$i<=97;$i++)
    {

	for ($j=0; $j<=97;$j++)
	{
	   my $temp = substr($spmlines[$i],$j,1);
	   $spmatrix[$i][$j] =  $temp;
	   $rows[$j]=1;
	}
    }

push (@lines,"@");

foreach $line(@lines)                ### Read the input file, one line at a time ###
    {
	$endl=1;			### To control the loop till the end of the line is reached ###
	if ($flags[1])
	{
	    push (@outputLines, "$line");
	}
	  
       
     {
       while($endl)			####  Entering the sequential If-else to check for various matches  ####
	{
	    
   
    {         
	   
	if ($line=~ /\G.*\*\//gc)	####  Checking for comments  ####
	{
	    $comFlag = 0;
	}
	
	 elsif ($comFlag==1)
	{
	    $endl = 0;
	}
	
	elsif ($line=~ /\G\/\*.*/gc)
	{
	 $comFlag = 1 ;
	}
	
	
	elsif ($line=~ /\G\/\//gc)
	{
	    $endl = 0;
	}
	   
	elsif($line=~ /\G##.*##/gc)			####  Checking for flags  ####
	{
	    parseFlags ($&);
	    printFlags ();
	}
      
	elsif($line=~ /\G\s+/gc)			#### Check for whitespace ####
	{}
	    
	elsif (($line =~ /\G[a-z]+([a-z]|[0-9]|_)*/gc)) #Identifier#
	{
	    if (length ($&) <= 16)
	    {
		if ($parseTokenCode{"$&"})
		{
		    $inputString=$parseTokenCode{$&};#push(@inputString, $&);
                    $ipStr=$&;
                    #print "INPUTSTRING: $inputString\n";
                    parser();
		}
		else
		{
		    if ($flags[2])
		    {
			#push (@outputLines, "\t\t\t\t\t\tCODE " . $tokenCode{'identifier'} . " RETURNED FOR TOKEN $&");
		    }
		    $inputString= $parseTokenCode{"var"};#push (@inputString, "var");
                    $ipStr=$&;
                    parser();
		}
	    }
	    else
	    {
		#push (@outputLines, "\n\t\t\t\t\t\tInvalid Identifier: $&\n ");
		#print "Invalid Identifier: $&\n";
	    }
	}
   
	elsif (($line =~ /\G([A-Z]+([A-Z]|_)*)/gc))
	{   # Regular Expression for Reserve Words #
	    if($reservedWords{"$&"})
	    {
		if ($flags[2])
		{
		    #push (@outputLines, "\t\t\t\t\t\tCODE " . $reservedWords{"$&"} . " RETURNED FOR TOKEN $&");
		    
		}
		$inputString=$parseTokenCode{$&};#push (@inputString, $&);
                $ipStr=$&;
                parser();
	    }
	    else
	    {
		#push (@outputLines, "\n\t\t\t\t\t\tInvalid Reserved Word: $&\n ");
		#print "Invalid Reserved Word: \n$&\n";
	    }       # print "Reserved Word: $&\n";
	     my $i=0;
	}
    
	elsif (($line =~ /\G(==|!=|<=|>=|<-|::)/gc))  #####  Regular Expression for Multiple ASCII  #####
	{
	    if ($flags[2])
	    {
		#push (@outputLines, "\t\t\t\t\t\tCODE " . $multiAscii{"$&"} . " RETURNED FOR TOKEN$&");
		
	    }
	    $inputString= $parseTokenCode{$&};#push (@inputString, $&);
            $ipStr=$&;
            parser();
	}
  
    
	elsif($line =~ m/\G[^\w\s]/gc)            ####  Regular Expression for ASCII  ####
	{
	    if($& =~ /(\;|\,|\[|\]|\(|\)|\:|\!|\<|\>|\+|\-|\*|\/|\{|\}|\&|\||\~)/)	
	    {
		if ($flags[2])
		{
		    #push (@outputLines, "\t\t\t\t\t\tCODE " . $ascii{"$&"} . " RETURNED FOR TOKEN $&");
		}
		$inputString= $parseTokenCode{$&};#push (@inputString, $&);
                $ipStr=$&;
                parser();
	    }
	    else
	    {
		#push (@outputLines, "\n\t\t\t\t\t\tInvalid ASCII: $&\n ");
	    #print "ASCII $& is invalid\n";
	    }
	}
   
      
    elsif ($line =~ /\G[+-]?(\d+\.\d+|\.\d+)/gc) {      ####  Checking for Real Numbers  ####
	my $float=$&;
	$float =~ s/^0+//g;
	$float =~ s/0+$//g;
	
	if (length($float)<8)
	{
		if ($flags[2])
		{
		    #push (@outputLines, "\t\t\t\t\t\tCODE " . $parseTokenCode{'real'} . " RETURNED FOR TOKEN $float");
		}
		$inputString= $parseTokenCode{"real"};#push (@inputString, "real");
                $ipStr=$&;
                parser();
	    
	}    
	else
	{
	    #push (@outputLines, "\n\t\t\t\t\t\tInvalid Real: $&\n ");
	 #print (" $float is an invalid real \n");
	}
	 
	}
      
       elsif ($line =~ /\G[+-]?\d+/gc) {            #####  Checking for integers  #####
	if (length($&)<10)
	{
	    
	if ($flags[2])
	{
	    #push (@outputLines, "\t\t\t\t\t\tCODE " . $tokenCode{'int'} . " RETURNED FOR TOKEN $&");
	}
	$inputString = $parseTokenCode{"integer"};#push (@inputString, "integer");
        $ipStr=$&;
        parser();
	}
	else {
	    #push (@outputLines, "\n\t\t\t\t\t\tInvalid Integer: $&\n ");
#            print (" $& is an invalid integer \n");
	}
	   }
       elsif($line =~/@/)
       {
        $inputString="@";
        parser();
       }
	
	else {
	    $endl=0;
	}
   
	    }
	}
    }
    }
    
sub printOutLines
{
	open (OUTPUT, ">>$outputFile") or die "Cant find the specified file: $!\n";
	
	for my $out (@outputLines)
	{
		print OUTPUT "$out\n";
	}
	
	close (OUTPUT);
        
        open (FTOUTPUT, ">$fTuple") or die "Cant find the specified file: $!\n";
	
	for my $out1 (@ftupleOutput)
	{
		print FTOUTPUT "$out1\n";
	}
	
	close (FTOUTPUT);
}

sub printGrpDetail
{
	open (OUTPUT, ">$outputFile") or die "Error: Cannot open file: $!\n";
	print OUTPUT "\t\t\t\t\t\tPRAGMATICS\n";
	print OUTPUT "\t\t\t\t\tManas Karekar - mkareka\@clemson.edu\n";
	print OUTPUT "\t\t\t             Yashodhan Fadnavis - yfadnav\@clemson.edu\n";
	print OUTPUT "\t\t\t\t\t    " . localtime() . "\n";
	print OUTPUT "======================================================================================================\n";
	close (OUTPUT);
}

sub initFlags						####  Initialising the flags  ####
{
	for (my $i = 0; $i < $TOTALFLAGS; $i ++)
	{
		$flags[$i] = 0;
	}
	
	$flags[1] = 1;
}

sub clearAllFlags					####  Clearing Flags  ####
{
	for ( $i = 0; $i < $TOTALFLAGS; $i ++)
	{
		$flags[$i] = 0;
	}
}

sub setAllFlags						####  Setting Flags  ####
{
	for (my $i = 0; $i < $TOTALFLAGS; $i ++)
	{
		$flags[$i] = 1;
	}
}

sub parseFlags
{
	my $flag = shift @_;
	
	$flag =~ s/^##//;
	
	#while($linlen)
	FLAGCHK:
	{
		$flag =~ s/\s+//g;
		
		if ($flag =~ /\G\+(\d+)/gc)
		{
			if ($1 == 0)
			{
				setAllFlags();
			}
			elsif ($1 > $TOTALFLAGS)
			{
				print "Flag $1 does not exist\n";
			}
			else
			{
				$flags[$1] = 1;
			}
			redo FLAGCHK;
		}
		
		elsif ($flag =~ /\G\-(\d+)/gc)
		{
			if ($1 == 0)
			{
				clearAllFlags();
			}
			elsif ($1 > $TOTALFLAGS)
			{
				print "Invalid Flag Index: $1\n";
			}
			else
			{
				$flags[$1] = 0;
			}
			redo FLAGCHK;
		}
		
		elsif ($flag =~ /\G##/gc)
		{
			return;
		}
	}
	return;	
}

sub printFlags
{
	print "The flag(s) which are SET are:\n";
	for (my $i = 0; $i < $TOTALFLAGS; $i++)
	{
		
		if($flags[$i])
		{
		print "FLAG " . ($i) . ": $flags[$i]\n";
		}
	}
	print "All other flags are 0\n\n";
	
}

#############################################################################################################################

##PARSER
#############################################################################################################################
my $inputSymbol;
my $putInStack=1;
my $charErr;
my $goodRed;
my$end=2;
my $pragCount=0;



#$comePanic=0;
sub parser
{
my $key;
my $value;
my $stackTopKey;
my $inputStringKey;
$redFlag=1;
my $tempFlag=0;
#print "$inputString\n";
#getInputStringCodesTop();
#print "getinputstringcodetop: $inputString";
 getStackTop();
 #print "\nStack is: @stack\n";

#while($inputString ne '@' && $stackTop ne 1||$end==1)  #while token codes are exhausted or stackTop is start symbol
if($comePanic==1)
{
    panicMode();
}
while($redFlag==1)
{
    
    if($stackTop eq '@')                #check whether this is the 1st token or not
    {
	#my $inputSymbol = pop @inputStringCodes;   #pop symbol from inputString and push onto Stack
	push (@stack,$inputString);getStackTop();
        #$inputString="";
	push (@semStack, $ipStr);getSemStackTop();
        $redFlag=0;
	#getInputStringCodesTop();
	#print "StackTop is : $stackTop\n";
	#print "InputStringCodesTop is: $inputString\n";
    }
    else
    {
        if($inputString eq'@')
	{
	    $relation=2;
	}
        else
        {
	$relation = $spmatrix[$stackTop-1][$inputString-1];
        if($flags[9] == 1)
        {
            push (@outputLines, "\t\t\t\t\t\t--------------------------");
            while (($key,$value) = each(%parseTokenCode)){
                                                if($value == $stackTop)
                                                {
                                                    $stackTopKey=$key;
                                                }
                                            }
            push (@outputLines, "\t\t\t\t\t\tTop of the Stack is : $stackTopKey\n");
            while (($key,$value) = each(%parseTokenCode)){
                                                if($value == $inputString)
                                                {
                                                    $stackTopKey=$key;
                                                }
                                            }
            push (@outputLines, "\t\t\t\t\t\tInput Symbol is: $stackTopKey\n");
            push (@outputLines,  "\t\t\t\t\t\tRelation is: $relation\n");
            push (@outputLines, "\t\t\t\t\t\t--------------------------");
	}
        }
        #print "StackTop is : $stackTop\n";
	#print "InputStringCodesTop is: $inputString\n";
	#print "new RELATION IS: $relation\n";
	if($relation==0)
	{
       	    print ("Character Pair Error \n");
            while (($key,$value) = each(%parseTokenCode)){
                                                if($value == $stackTop)
                                                {
                                                    $stackTopKey=$key;
                                                }
                                                if($value == $inputString)
                                                {
                                                    $inputStringKey=$key;
                                                }
                                            }
            push (@outputLines, "\n\t\t\t\t\t\tCharacter Pair Error encountered. No relation between $stackTopKey & $inputStringKey");
            push (@outputLines, "\n\t\t\t\t\t\tTrying to recover...");
            push (@outputLines, "\n\t\t\t\t\t\tSymbols ignored while recovering: ");
            #$charErr=1;
            panicMode();
            # pop the current set and move on to maintain panic recovery mode #
	}
	elsif($relation==1||$relation==3)
	{
	    # Equals Relation OR # Less than
            $redFlag=0;
	    #$inputSymbol = pop @inputStringCodes;   #pop symbol from inputString and push onto Stack
	    push (@stack,$inputString);getStackTop();
            push (@semStack, $ipStr);getSemStackTop();
	    
	    #getInputStringCodesTop();
	    #print "StackTop is $stackTop and inputStringCodesTop is $inputString\n";
	}
	elsif($relation==2)
	{
            if($flags[8] == 1)
            {
                    #print the symbolic stack before the reduction
                    push (@outputLines, "\t\t\t\t\t\t--------------------------");
                    push (@outputLines, "\n\t\t\t\t\t\tStack before the reduction: ");
                    foreach(@stack)
                    {
                        while (($key,$value) = each(%parseTokenCode)){
                                                if($value == $_)
                                                {
                                                    $stackTopKey=$key;
                                                }
                                            }
                        push (@outputLines, "\t\t\t\t\t\t".$stackTopKey." ");
                    }
		    push (@outputLines, "\n");
                    push (@outputLines, "\t\t\t\t\t\t--------------------------");
            }
	    do
	    {
		getStackTop();                 
		$inputSymbol = pop @stack; getStackTop();
                push (@handle, $inputSymbol);getHandleTop();
		
		
		if($stackTop eq '@')
		{
			$relation=3;
#			print "Relation is lesser than\n";
		}
		else
		{
		    $relation = $spmatrix[$stackTop-1][$handleTop-1];
		    #print " stackhandle relation: $relation\n"
		}
       
	    }
	    while($relation==1);
    
	    if($relation==3)
	    {
		if($flags[10] == 1)
                                    {
                                        push (@outputLines, "\t\t\t\t\t\t--------------------------");
                                        push (@outputLines,  "\n\t\t\t\t\t\tHandle before reduction: ");
                                        foreach (@handle)
                                        {
                                            while (($key,$value) = each(%parseTokenCode)){
                                                if($value == $_)
                                                {
                                                    $stackTopKey=$key;
                                                }
                                            }
                                            push (@outputLines,  "\t\t\t\t\t\t".$stackTopKey." ");
                                        }
                                        push (@outputLines, "\t\t\t\t\t\t\n");
                                        push (@outputLines, "\t\t\t\t\t\t--------------------------");
                                    }
		
		$k=0;
		my $matchProd = 0;
		
		for($k=0;$k<109;$k++)
		{
		    
			my $handleLength = scalar @handle;
		       
			
			if($plist[$k][0]==$handleLength&&$matchProd==0)
			{
				
				$i=0; $j=1;
				
				my $handleLen=$handleLength;
                                $flagHLen = $handleLength;
				#print "Handle length is : $handleLen\n";
				while(($handle[$handleLen-1] == $plist[$k][$j])&&$handleLen!=0)
				{
				    #print "Handle, production element are matched once\n";
                                    $handleLen--;
                                    $j++;
				}
			    
				if($j==$handleLength+1)
				{
				    $matchProd=1;
                                    				    
	#			    print ("Production Match found $k+1\n");
				    push(@stack, $plist[$k][$j]);
				    #print "REDNUM: $redNum\n";
                                    $redNum=($k+1);
                                    #print "REDNUM: $redNum\n";
				    getStackTop();
		#		    print "StackTop is : $stackTop\n";
                                    if($flags[12]==1)
                                    {
                                        print "Semantic Stack before reduction: \n";
                                         $semLen = scalar @semStack;
                                        for($i=0;$i<= $semLen; $i++)
                                          {
                                            for($j=0;$j<5;$j++)
                                        
                                              {
                                                  print $semStack[$i][$j]." | ";
                                              }
                                              print "\n";
                                          }
                                    }
                                    semantics();                    ################CALL SEMANTICS################
                                    if($flags[12]==1)
                                    {
                                        print "Semantic Stack after reduction: \n";
                                        $semLen = scalar @semStack;
                                        for($i=0;$i<= $semLen; $i++)
                                          {
                                            for($j=0;$j<5;$j++)
                                        
                                              {
                                                  print $semStack[$i][$j]." | ";
                                              }
                                              print "\n";
                                          }
                                    }
                                    if($stackTop!=1)
                                    {
                                    $redFlag=1;
                                    }
                                    else
                                    {
                                        $redFlag=0;
                                        if($flags[7] == 1)
                                        {
                                            while (($key,$value) = each(%parseTokenCode)){
                                                $count++;
                                                if($value == $stackTop)
                                                {
                                                    $stackTopKey=$key;
                                                }
                                            }
                                    #print the reduction
                                    push (@outputLines, "\t\t\t\t\t\t--------------------------");
                                    push (@outputLines,  "\t\t\t\t\t\tReduction $redNum :".$stackTopKey ." --> ");
                                    
                                    #push (@outputLines,  $stackTop ." --> ");
                                    
                                    for ($i = 1; $i <=$flagHLen  ;$i++)
                                    {
                                        while (($key,$value) = each(%parseTokenCode)){
                                        if($value == $plist[($redNum-1)][$i])
                                        {
                                            $stackTopKey=$key;
                                        }
                                        }
                                        push (@outputLines, "\t\t\t\t\t\t".$stackTopKey."  ");
					
                                    }                                
                                    push (@outputLines, "\t\t\t\t\t\t\n");
                                    push (@outputLines, "\t\t\t\t\t\t--------------------------");
                                        }
				    
                                    if($flags[8] == 1)
                                    {
                                        #print the symbolic stack before the reduction
                                        push (@outputLines, "\t\t\t\t\t\t--------------------------");
                                        push (@outputLines, "\n\t\t\t\t\t\tStack after reduction :");
                                        foreach(@stack)
                                        {
                                            while (($key,$value) = each(%parseTokenCode)){
                                                if($value == $_)
                                                {
                                                    $stackTopKey=$key;
                                                }
                                            }
                                            push (@outputLines,  "\t\t\t\t\t\t".$stackTopKey." ");
                                        }
                                        push (@outputLines,  "\n");
                                        push (@outputLines, "\t\t\t\t\t\t--------------------------");
                                    }   
                                        printOutLines ();
                                        
                                        
                                        goto PRAGMATICS;            #### GOTO PRAGMATICS##############
                                        exit;
                                    }
                                    
                                    
                                    
                                    #if($handle[0]==54)
                                    #{
                                    #    $goodRed=$plist[$k][$j];
                                    #}
				    
				    #foreach(@handle)
				    
					@handle=();
                                        $k = 110; 
				    
                                   
				}
                                
				
			}
			
		}
                                if($flags[7] == 1)
                                {
                                    while (($key,$value) = each(%parseTokenCode)){
                                        if($value == $stackTop)
                                        {
                                            $stackTopKey=$key;
                                        }
                                    }

                                    #print the reduction
                                    push (@outputLines, "\t\t\t\t\t\t--------------------------");
                                    push (@outputLines,  "\t\t\t\t\t\tReduction $redNum :".$stackTopKey ." --> ");
                                    
                                    #push (@outputLines,  $stackTop ." --> ");
                                    
                                    for ($i = 1; $i <=$flagHLen  ;$i++)
                                    {
                                        while (($key,$value) = each(%parseTokenCode)){
                                        if($value == $plist[($redNum-1)][$i])
                                        {
                                            $stackTopKey=$key;
                                        }
                                        }
                                        push (@outputLines, "\t\t\t\t\t\t".$stackTopKey."  ");
					
                                    }                                
                                    push (@outputLines, "\t\t\t\t\t\t\n");
                                    push (@outputLines, "\t\t\t\t\t\t--------------------------");
                                }
				    
                                    if($flags[8] == 1)
                                    {
                                        #print the symbolic stack before the reduction
                                        push (@outputLines, "\t\t\t\t\t\t--------------------------");
                                        push (@outputLines, "\n\t\t\t\t\t\tStack after reduction :");
                                        foreach(@stack)
                                        {
                                            while (($key,$value) = each(%parseTokenCode)){
                                                if($value == $_)
                                                {
                                                    $stackTopKey=$key;
                                                }
                                            }
                                            push (@outputLines,  "\t\t\t\t\t\t".$stackTopKey." ");
                                        }
                                        push (@outputLines,  "\n");
                                        push (@outputLines, "\t\t\t\t\t\t--------------------------");
                                    }   
                if($matchProd==0)
                {
                    print "Error Encountered Reducibility   ST: $stackTop         GR: $goodRed"; 
                    panicMode();
                }
	      

		    #print "StackTop after reduction $rednum is $stackTop\n";
		    $putInStack=0;
	    }
	    else
	    {
		print "There is an error";
		$relation = $spmatrix[$stackTop][$handleTop];
	    }
	} #elsif ends
    }#else ends

}#while ends
}

sub panicMode
{
    my $key1; my $value1; my $stackTopKey1;
    while ($stackTop!=6&&$stackTop!=21)
    {
        getStackTop();
        while (($key1,$value1) = each(%parseTokenCode)){
                                                if($value1 == $stackTop)
                                                {
                                                    $stackTopKey1=$key1;
                                                }
                                            }
                                            push (@outputLines,  "\t\t\t\t\t\t".$stackTopKey1." ");
        #print "Stackt123p: $stackTop\n";
        $inputSymbol=pop @stack;
        getStackTop();
    }
    if($inputString!=54)
    {
        while (($key1,$value1) = each(%parseTokenCode)){
                                                if($value1 == $inputString)
                                                {
                                                    $stackTopKey1=$key1;
                                                }
                                            }
        push (@outputLines,  "\t\t\t\t\t\t".$stackTopKey1." ");
        
        $comePanic=1;
    }
    else
    {
        push (@outputLines, "\n\t\t\t\t\t\tLine Ignored. End of Panic Mode ");
        $comePanic=0;
    }
    $redFlag=0;
}


sub getStackTop
{
    
$stackTop = pop @stack;
push (@stack, $stackTop);
}

sub getSemStackTop
{
    
$semStackTop = pop @semStack;
push (@semStack, $semStackTop);
}

sub getInputStringCodesTop
{
$inputStringCodesTop = pop @inputStringCodes;
push (@inputStringCodes, $inputStringCodesTop);
}

sub getHandleTop
{
    $handleTop = pop @handle;
    push (@handle, $handleTop);
}



##########################################################################################
#                                       SEMANTICS
##########################################################################################
sub semantics
{
    if($redNum==1)
    {
	for(1..3)
	{
	    pop @semStack;
	}
	push (@semStack,"start");
	    printTuple("-","PROGRAMEND","-","-");
	if($flags[16]==1)
	{
	    $symTabLen = scalar @symTab;
	    push (@outputLines, "\t\t\t\t\t\tFinal Symbol table is: \n");
	    push (@outputLines, "\t\t\t\t\t\tName | Type | Shape | No.Rows | No.Columns\n");
	     for($i=0 ;$i<$symTabLen;$i++)
	     {
		my @temp;
                for($j=0; $j<5; $j++)
		{
		    push (@temp, "$symTab[$i][$j] |");
		}
		push (@outputLines, join(' ', "\t\t\t\t\t\t@temp"));
	     }
        }
    }
    
    if($redNum==2)
    {
	pop @semStack;
	push (@semStack, $stackTop);
	
	    printTuple("-","PROGRAMBEGIN","-","-");
    }
    
    if($redNum==3)
    {
	for(1..3)
	{
	    pop @semStack;
	}
	push (@semStack, $stackTop);
    }
    
    if($redNum==4)
    {
	for(1..2)
	{
	    pop @semStack;
	}
	push (@semStack, $stackTop);
    }
    
    if($redNum==5)
    {
	for(1..3)
	{
	    pop @semStack;
	}
	push (@semStack, $stackTop);
	
	    printTuple("-","DECLARATIONEND","-","-");
    }
    
    if($redNum==6)
    {
	pop @semStack;
	push (@semStack, $stackTop);
    }
    
    if($redNum==7)
    {
	for(1..3)
	{
	    pop @semStack;
	}
	push(@semStack, $stackTop);
    }
    
    if($redNum==8)
    {
	for(1..2)
	{
	    pop @semStack;
	}
	push (@semStack, $stackTop);
	
    }
    
    if($redNum==9)
    {
	pop @semStack;
	push (@semStack, $stackTop);
    }
    
    if($redNum==10)
    {
	$semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; 
	$localSTLen= scalar @localST;
	
	if($procFlag==0)
	{
	$a=0;
	if($a==0)
	{
	    $varDecl=0;
	}
	while($a!=$symTabLen&&$symTab[$a][0] ne $semStack[$semStackIndex])
	{
	    $varDecl=0;
	    $a++;    
	}
	if($a<$symTabLen&&$a!=0)
	{
	    $varDecl=1;
	}
	if($symTab[0][0] eq $semStack[$semStackIndex])
	{
	    $varDecl=1;
	}
	if($varDecl==0)
	{
	    $symTab[$symTabLen][0]=$semStack[$semStackIndex];
	    $symTab[$symTabLen][1]=$symTab[$semStack[$semStackIndex-2]][1];
	    $symTab[$symTabLen][2]=$symTab[$semStack[$semStackIndex-2]][2];
	    $symTab[$symTabLen][3]=$symTab[$semStack[$semStackIndex-2]][3];
	    $symTab[$symTabLen][4]=$symTab[$semStack[$semStackIndex-2]][4];
	    if($flags[15]==1)
	    {
		push (@outputLines, "\t\t\t\t\t\tJust entered, variable table entry: ");
                
		my @temp;
                for($j=0; $j<5; $j++)
		{
	        push (@temp, "$symTab[$symTabLen][$j] |");
		}
		push (@outputLines, join(' ', "\t\t\t\t\t\t@temp"));   
	    }
	    
	    printTuple($semStack[$semStackIndex],"MEMORY",$symTab[$symTabLen][3],$symTab[$symTabLen][4]);
    
	
	for(1..3)
	{
	    pop @semStack;
	}
	push (@semStack,$symTabLen);
	}
	else
	{
	    push (@outputLines, "\t\t\t\t\t\tERROR: The variable $semStack[$semStackIndex] is already declared\n");
            push (@outputLines, "\t\t\t\t\t\tIgnoring this declaration\n");
	}
	}
	
	else
	{
	$a=0;
	if($a==0)
	{
	    $varDecl=0;
	}
	while($a!=$localSTLen&&$localST[$a][0] ne $semStack[$semStackIndex])
	{
	    $varDecl=0;
	    $a++;
	    
	}
	if($a<$localSTLen&&$a!=0)
	{
	    $varDecl=1;
	}
	if($localST[0][0] eq $semStack[$semStackIndex])
	{
	    $varDecl=1;
	}
	if($varDecl==0)
	{
	    $localST[$localSTLen][0]=$semStack[$semStackIndex];
	    $localST[$localSTLen][1]=$localST[$semStack[$semStackIndex-2]][1];
	    $localST[$localSTLen][2]=$localST[$semStack[$semStackIndex-2]][2];
	    $localST[$localSTLen][3]=$localST[$semStack[$semStackIndex-2]][3];
	    $localST[$localSTLen][4]=$localST[$semStack[$semStackIndex-2]][4];
	    if($flags[15]==1)
	    {
		push (@outputLines, "\t\t\t\t\t\tJust entered, variable table entry: ");
                
		my @temp;
                for($j=0; $j<5; $j++)
		{
		    push (@temp, "$localST[$localSTLen][$j] |");
		}
		push (@outputLines, join(' ', "\t\t\t\t\t\t@temp"));   
	    }
         
        printTuple($semStack[$semStackIndex],"MEMORY","-","-");
	
	
	for(1..3)
	{
	    pop @semStack;
	}
	push (@semStack,$localSTLen);
	}
	else
	{
	    push (@outputLines, "\t\t\t\t\t\tERROR: The variable $semStack[$semStackIndex] is already declared\n");
            push (@outputLines, "\t\t\t\t\t\tIgnoring this declaration\n");
	}
	    
	}
    }

    if($redNum==11)
    {
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; 
	$localSTLen= scalar @localST;
	
	if($procFlag==0)
	{
	$a=0;
	if($a==0)
	{
	    $varDecl=0;
	}
	while($a!=$symTabLen&&$symTab[$a][0] ne $semStack[$semStackIndex])
	{
	    $varDecl=0;
	    $a++;
	    
	}
	if($a<$symTabLen&&$a!=0)
	{
	    $varDecl=1;
	}
	if($symTab[0][0] eq $semStack[$semStackIndex])
	{
	    $varDecl=1;
	}
	if($varDecl==0)
	{
            $symTab[$symTabLen][0]=$semStack[$semStackIndex];
	    $symTab[$symTabLen][1]=$semStack[$semStackIndex-1];
	    $symTab[$symTabLen][2]="scalar";
	    $symTab[$symTabLen][3]="-";
	    $symTab[$symTabLen][4]="-";
	    
	    if($flags[15]==1)
	    {
		push (@outputLines, "\t\t\t\t\t\tJust entered, variable table entry: ");
                
		my @temp;
                for($j=0; $j<5; $j++)
		{
		    push (@temp, "$symTab[$symTabLen][$j] |");
		}
		push (@outputLines, join(' ', "\t\t\t\t\t\t@temp"));   
	    }
	    
	    printTuple($semStack[$semStackIndex],"MEMORY","-","-");
	
	for(1..2)
	{
	    pop @semStack;
	}
	push (@semStack,$symTabLen);
	}
	else
	{
	    push (@outputLines, "\t\t\t\t\t\tERROR: The variable $semStack[$semStackIndex] is already declared\n");
            push (@outputLines, "\t\t\t\t\t\tIgnoring this declaration\n");
	}
	}
	
	else
	{
	$a=0;
	if($a==0)
	{
	    $varDecl=0;
	}
	while($a!=$localSTLen&&$localST[$a][0] ne $semStack[$semStackIndex])
	{
	    $varDecl=0;
	    $a++;
	}
	if($a<$localSTLen&&$a!=0)
	{
	    $varDecl=1;
	}
	if($localST[0][0] eq $semStack[$semStackIndex])
	{
	    $varDecl=1;
	}
	if($varDecl==0)
	{
	    $localST[$localSTLen][0]=$semStack[$semStackIndex];
	    $localST[$localSTLen][1]=$semStack[$semStackIndex-1];
	    $localST[$localSTLen][2]="scalar";
	    $localST[$localSTLen][3]="-";
	    $localST[$localSTLen][4]="-";
	    if($flags[15]==1)
	    {
		push (@outputLines, "\t\t\t\t\t\tJust entered, variable table entry: ");
                
		my @temp;
                for($j=0; $j<5; $j++)
		{
		    push (@temp, "$localST[$localSTLen][$j] |");
		}
		push (@outputLines, join(' ', "\t\t\t\t\t\t@temp"));   
	    }          
	    printTuple($semStack[$semStackIndex],"MEMORY","-", "-");
	
	for(1..2)
	{
	    pop @semStack;
	}
	push (@semStack,$localSTLen);
	}
	else
	{
	    push (@outputLines, "\t\t\t\t\t\tERROR: The variable $semStack[$semStackIndex] is already declared\n");
            push (@outputLines, "\t\t\t\t\t\tIgnoring this declaration\n");
	}
	}
	
    }
    
    if($redNum==12)
    {
	print "Prod $redNum\n";
	$semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; 
	$localSTLen= scalar @localST;
	
	if($procFlag==0)
	{
	$a=0;
	if($a==0)
	{
	    $varDecl=0;
	}
	while($a!=$symTabLen&&$symTab[$a][0] ne $semStack[$semStackIndex])
	{
	    $varDecl=0;
	    $a++;
	    
	}
	if($a<$symTabLen&&$a!=0)
	{
	    $varDecl=1;
	}
	if($symTab[0][0] eq $semStack[$semStackIndex])
	{
	    $varDecl=1;
	}
	if($varDecl==0)
	{
	    $symTab[$symTabLen][0]=$semStack[$semStackIndex];
	    $symTab[$symTabLen][1]=$semStack[$semStackIndex-2];
	    $symTab[$symTabLen][2]="vector";
	    $symTab[$symTabLen][3]=$semStack[$semStackIndex-1];
	    $symTab[$symTabLen][4]="-";
	    
	    if($flags[15]==1)
	    {
		push (@outputLines, "\t\t\t\t\t\tJust entered, variable table entry: ");
                
		my @temp;
                for($j=0; $j<5; $j++)
		{
		    push (@temp, "$symTab[$symTabLen][$j] |");
		}
		push (@outputLines, join(' ', "\t\t\t\t\t\t@temp"));
	     
		    
	    }
	    
	    printTuple($semStack[$semStackIndex],"MEMORY",$semStack[$semStackIndex-1], "-");
    
	
	for(1..3)
	{
	    pop @semStack;
	}
	push (@semStack,$symTabLen);
	}
	else
	{
	    push (@outputLines, "\t\t\t\t\t\tERROR: The variable $semStack[$semStackIndex] is already declared\n");
            push (@outputLines, "\t\t\t\t\t\tIgnoring this declaration\n");
	}
	}
	
	else
	{
	$a=0;
	if($a==0)
	{
	    $varDecl=0;
	}
	while($a!=$localSTLen&&$localST[$a][0] ne $semStack[$semStackIndex])
	{
	    $varDecl=0;
	    $a++;
	    
	}
	if($a<$localSTLen&&$a!=0)
	{
	    $varDecl=1;
	}
	if($localST[0][0] eq $semStack[$semStackIndex])
	{
	    $varDecl=1;
	}
	if($varDecl==0)
	{
	    $localST[$localSTLen][0]=$semStack[$semStackIndex];
	    $localST[$localSTLen][1]=$semStack[$semStackIndex-2];
	    $localST[$localSTLen][2]="vector";
	    $localST[$localSTLen][3]=$semStack[$semStackIndex-1];
	    $localST[$localSTLen][4]="-";
	    if($flags[15]==1)
	    {
		push (@outputLines, "\t\t\t\t\t\tJust entered, variable table entry: ");
                
		my @temp;
                for($j=0; $j<5; $j++)
		{
		    push (@temp, "$localST[$localSTLen][$j] |");
		}
		push (@outputLines, join(' ', "\t\t\t\t\t\t@temp"));   
	    }
	
        printTuple($semStack[$semStackIndex],"MEMORY",$semStack[$semStackIndex-1],"-");
	
	
	for(1..3)
	{
	    pop @semStack;
	}
	push (@semStack,$localSTLen);
	}
	else
	{
	    push (@outputLines, "\t\t\t\t\t\tERROR: The variable $semStack[$semStackIndex] is already declared\n");
            push (@outputLines, "\t\t\t\t\t\tIgnoring this declaration\n");
	}
	}
    }
    
    if($redNum==13)
    {
	print ("Prod $redNum\n");
	$semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; 
	$localSTLen= scalar @localST;
	
	if($procFlag==0)
	{
	$a=0;
	if($a==0)
	{
	    $varDecl=0;
	}
	while($a!=$symTabLen&&$symTab[$a][0] ne $semStack[$semStackIndex])
	{
	    $varDecl=0;
	    $a++;
	    
	}
	if($a<$symTabLen&&$a!=0)
	{
	    $varDecl=1;
	}
	if($symTab[0][0] eq $semStack[$semStackIndex])
	{
	    $varDecl=1;
	}
	if($varDecl==0)
	{
	    $symTab[$symTabLen][0]=$semStack[$semStackIndex];
	    $symTab[$symTabLen][1]=$semStack[$semStackIndex-4];
	    $symTab[$symTabLen][2]="matrix";
	    $symTab[$symTabLen][3]=$semStack[$semStackIndex-3];
	    $symTab[$symTabLen][4]=$semStack[$semStackIndex-1];
	    
	    if($flags[15]==1)
	    {
		push (@outputLines, "\t\t\t\t\t\tJust entered, variable table entry: ");
                
		my @temp;
                for($j=0; $j<5; $j++)
		{
		    push (@temp, "$symTab[$symTabLen][$j] |");
		}
		push (@outputLines, join(' ', "\t\t\t\t\t\t@temp"));	    
	    }
	    
	
	    printTuple($semStack[$semStackIndex],"MEMORY",$semStack[$semStackIndex-3], $semStack[$semStackIndex-1]);
	
	
	for(1..5)
	{
	    pop @semStack;
	}
	push (@semStack,$symTabLen);
	}
	else
	{
	    push (@outputLines, "\t\t\t\t\t\tERROR: The variable $semStack[$semStackIndex] is already declared\n");
            push (@outputLines, "\t\t\t\t\t\tIgnoring this declaration\n");
	}
	}
	
	else
	{
	$a=0;
	if($a==0)
	{
	    $varDecl=0;
	}
	while($a!=$localSTLen&&$localST[$a][0] ne $semStack[$semStackIndex])
	{
	    $varDecl=0;
	    $a++;
	    
	}
	if($a<$localSTLen&&$a!=0)
	{
	    $varDecl=1;
	}
	if($localST[0][0] eq $semStack[$semStackIndex])
	{
	    $varDecl=1;
	}
	if($varDecl==0)
	{
	    $localST[$localSTLen][0]=$semStack[$semStackIndex];
	    $localST[$localSTLen][1]=$semStack[$semStackIndex-4];
	    $localST[$localSTLen][2]="matrix";
	    $localST[$localSTLen][3]=$semStack[$semStackIndex-3];
	    $localST[$localSTLen][4]=$semStack[$semStackIndex-1];
	    if($flags[15]==1)
	    {
		push (@outputLines, "\t\t\t\t\t\tJust entered, variable table entry: ");
                
		my @temp;
                for($j=0; $j<5; $j++)
		{
		    push (@temp, "$localST[$localSTLen][$j] |");
		}
		push (@outputLines, join(' ', "\t\t\t\t\t\t@temp"));   
	    }
	
        printTuple($semStack[$semStackIndex],"MEMORY",$semStack[$semStackIndex-3], $semStack[$semStackIndex-1]);
		
	for(1..5)
	{
	    pop @semStack;
	}
	push (@semStack,$localSTLen);
	}
	else
	{
	    push (@outputLines, "\t\t\t\t\t\tERROR: The variable $semStack[$semStackIndex] is already declared\n");
            push (@outputLines, "\t\t\t\t\t\tIgnoring this declaration\n");
	}
	}
	
    }
    if($redNum==14)
    {
	print "Prod $redNum\n";
	pop @semStack;getSemStackTop();
	push (@semStack, "integer");getSemStackTop();
    }
    if($redNum==15)
    {
	print "Prod $redNum\n";
	pop @semStack;getSemStackTop();
	push (@semStack, "real");getSemStackTop();
    }
    if($redNum==16)
    {
	print ("Prod $redNum \n NULL");
	pop @semStack; getSemStackTop();
	push (@semStack,"procpart");getSemStackTop();
    }
    if($redNum==17)
    {
	print ("Prod $redNum \n NULL");
	for(1..2)
	{
	pop @semStack; getSemStackTop();
	}
	push (@semStack,"proclist");getSemStackTop();
    }
    if($redNum==18)
    {
	print ("Prod $redNum \n NULL");
	pop @semStack; getSemStackTop();
	push (@semStack,"proclist");getSemStackTop();
    }
    
    if($redNum==19)
    {
	print ("Prod $redNum \n");
	$semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab;
	$localSTLen = scalar @localST;
	
	    printTuple($localST[$semStack[$semStackIndex-3]][0],"PROCEDUREEND","-","-");
	
	for(1..3)
	{
	    pop @semStack;
	}
	if($flags[14]==1)
	{
	    $localSTLen = scalar @localST;
	    push (@outputLines, "\t\t\t\t\t\tVariable Symbol Table: \n");
	    push (@outputLines, "\t\t\t\t\t\tName | Type | Shape | No.Rows | No.Columns\n");
	    for($i=0 ;$i<$localSTLen;$i++)
	     {
		my @temp;
                for($j=0; $j<5; $j++)
		{
		    push (@temp, "$localST[$i][$j] |");
		}
		push (@outputLines, join(' ', "\t\t\t\t\t\t@temp"));
	     }
            push (@outputLines, "\n");
	} 
	while($localSTLen!=0&&$localST[$localSTLen-1][1] ne "PROCEDURE")
	{
	    pop @localST;
	    $localSTLen--;
	    
	}
	    
	pop @localST;
	$procFlag--;
        
    }
    
     if($redNum==20)
    {
	print ("Prod $redNum \n");
	$semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab;
	$localSTLen = scalar @localST;
	
        printTuple($localST[$semStack[$semStackIndex-3]][0],"PROCEDUREEND","-","-");
	
	if($flags[14]==1)
	{
	    $localSTLen = scalar @localST;
	    push (@outputLines, "\t\t\t\t\t\tVariable Symbol Table: \n");
	    push (@outputLines, "\t\t\t\t\t\tName | Type | Shape | No.Rows | No.Columns\n");
	    for($i=0 ;$i<$localSTLen;$i++)
	     {
		my @temp;
                for($j=0; $j<5; $j++)
		{
		    push (@temp, "$localST[$i][$j] |");
		}
		push (@outputLines, join(' ', "\t\t\t\t\t\t@temp"));
	     }
            push (@outputLines, "\n");
	}         
	for(1..2)
	{
	    pop @semStack;
	}
		while($localSTLen!=0&&$localST[$localSTLen-1][1] ne "PROCEDURE")
	{
	    pop @localST;
	    $localSTLen--;
	}
	    
	pop @localST;
	$procFlag--;
    }
    
    if($redNum==21)
    {
	print ("Prod $redNum \n");
	    printTuple("-","NOFPARAMETERLIST","-","-");
	
    }
    
	
    if($redNum==22)
    {
	print ("Prod $redNum \n NULL");
    }
    
    if ($redNum==23)
    {
	print ("Prod $redNum \n");
	$semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab;
	$localSTLen = scalar @localST;
	if($procFlag==0)
	{
	$a=0;
	if($a==0)
	{
	    $varDecl=0;
	}
	while($a!=$symTabLen&&$symTab[$a][0] ne $semStack[$semStackIndex])
	{
	    $varDecl=0;
	    $a++;
	    
	}
	if($a<$symTabLen&&$a!=0)
	{
	    $varDecl=1;
	}
	if($symTab[0][0] eq $semStack[$semStackIndex])
	{
	    $varDecl=1;
	}
	if($varDecl==0)
	{
	$symTab[$symTabLen][0]=$semStack[$semStackIndex];
	$symTab[$symTabLen][1]="PROCEDURE";
	$symTab[$symTabLen][2]="-";
	$symTab[$symTabLen][3]="-";
	$symTab[$symTabLen][4]="-";
	if($flags[15]==1)
	    {
		push (@outputLines, "\t\t\t\t\t\tJust entered, variable table entry: ");
                
		my @temp;
                for($j=0; $j<5; $j++)
		{
		    push (@temp, "$symTab[$symTabLen][$j] |");
		}
		push (@outputLines, join(' ', "\t\t\t\t\t\t@temp"));
	     
		    
	    }
	$procFlag++;
	$semStack[$semStackIndex-1]=$symTabLen;
	    printTuple($semStack[$semStackIndex],"PROCEDURE","-","-");
        }
	else
	{
	    push (@outputLines, "\t\t\t\t\t\tERROR: The procedure name '$semStack[$semStackIndex]' is already used\n");
            push (@outputLines, "\t\t\t\t\t\tIgnoring this declaration\n");
	}
	}
        
	else
	{
	$a=0;
	if($a==0)
	{
	    $varDecl=0;
	}
	while($a!=$localSTLen&&$localST[$a][0] ne $semStack[$semStackIndex])
	{
	    $varDecl=0;
	    $a++;
	    
	}
	if($a<$localSTLen&&$a!=0)
	{
	    $varDecl=1;
	}
	if($localST[0][0] eq $semStack[$semStackIndex])
	{
	    $varDecl=1;
	}
	if($varDecl==0)
	{
	$localST[$localSTLen][0]= $semStack[$semStackIndex];
	$localST[$localSTLen][1]="PROCEDURE";
	$localST[$localSTLen][2]="-";
	$localST[$localSTLen][3]="-";
	$localST[$localSTLen][4]="-";
	if($flags[15]==1)
	    {
		push (@outputLines, "\t\t\t\t\t\tJust entered, variable table entry: ");
                
		my @temp;
                for($j=0; $j<5; $j++)
		{
		    push (@temp, "$localST[$localSTLen][$j] |");
		}
		push (@outputLines, join(' ', "\t\t\t\t\t\t@temp"));
	     
		    
	    }
	$procFlag++;
	$semStack[$semStackIndex-1]=$localSTLen;
	
	    printTuple($semStack[$semStackIndex],"PROCEDURE","-","-");
	}
	else
	{
	    push (@outputLines, "\t\t\t\t\t\tERROR: The procedure name '$semStack[$semStackIndex]' is already used\n");
            push (@outputLines, "\t\t\t\t\t\tIgnoring this declaration\n");
	}
	}
        
    }
    
    
    if($redNum==24)
    {
	print ("Prod $redNum \n");
	    printTuple("-","ENDFPARAMETERLIST","-","-");
	
	for(1..2)
	{            
	pop @semStack;
	}
	push (@semStack, "fparmlist");
    }
    
    if($redNum==25)
    {
       print ("Prod $redNum \n");
       $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab;
	$localSTLen= scalar @localST;
    
	if($procFlag==0)
	{
	    $symTab[$symTabLen][0]=$semStack[$semStackIndex];
	    $symTab[$symTabLen][1]=$semStack[$semStackIndex-1];
	    $symTab[$symTabLen][2]="scalar";
	    $symTab[$symTabLen][3]="-";
	    $symTab[$symTabLen][4]="-";
	    if($flags[15]==1)
	    {
		push (@outputLines, "\t\t\t\t\t\tJust entered, variable table entry: ");
                
		my @temp;
                for($j=0; $j<5; $j++)
		{
		    push (@temp, "$symTab[$symTabLen][$j] |");
		}
		push (@outputLines, join(' ', "\t\t\t\t\t\t@temp"));
	     
		    
	    }
	}
	else
	{
	    $localST[$localSTLen][0]=$semStack[$semStackIndex];
	    $localST[$localSTLen][1]=$semStack[$semStackIndex-1];
	    $localST[$localSTLen][2]="scalar";
	    $localST[$localSTLen][3]="null";
	    $localST[$localSTLen][4]="null";
	    if($flags[15]==1)
	    {
		push (@outputLines, "\t\t\t\t\t\tJust entered, variable table entry: ");
                
		my @temp;
                for($j=0; $j<5; $j++)
		{
		    push (@temp, "$localST[$localSTLen][$j] |");
		}
		push (@outputLines, join(' ', "\t\t\t\t\t\t@temp"));   
	    }    
	}
    
            #my $si2fparm = $semStack[$semStackIndex-2]."FPARAMETER";
	    printTuple($semStack[$semStackIndex],"FPARAMETER","-","-");

	
	for(1..5)
	{
	pop @semStack;
	}
	push (@semStack, "fparmlist-");
	
    }
    
    if($redNum==26)
    {
       print ("Prod $redNum \n");
       $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab;
	$localSTLen= scalar @localST;
    
	if($procFlag==0)
	{
	    $symTab[$symTabLen][0]=$semStack[$semStackIndex];
	    $symTab[$symTabLen][1]=$semStack[$semStackIndex-2];
	    $symTab[$symTabLen][2]="vector";
	    $symTab[$symTabLen][3]=$semStack[$semStackIndex-1];
	    $symTab[$symTabLen][4]="null";
	    
	    if($flags[15]==1)
	    {
		push (@outputLines, "\t\t\t\t\t\tJust entered, variable table entry: ");
                
		my @temp;
                for($j=0; $j<5; $j++)
		{
		    push (@temp, "$symTab[$symTabLen][$j] |");
		}
		push (@outputLines, join(' ', "\t\t\t\t\t\t@temp"));
	    }
	}
	else
	{
	    $localST[$localSTLen][0]=$semStack[$semStackIndex];
	    $localST[$localSTLen][1]=$semStack[$semStackIndex-2];
	    $localST[$localSTLen][2]="vector";
	    $localST[$localSTLen][3]=$semStack[$semStackIndex-1];
	    $localST[$localSTLen][4]="-";
	    if($flags[15]==1)
	    {
		push (@outputLines, "\t\t\t\t\t\tJust entered, variable table entry: ");
                
		my @temp;
                for($j=0; $j<5; $j++)
		{
		    push (@temp, "$localST[$localSTLen][$j] |");
		}
		push (@outputLines, join(' ', "\t\t\t\t\t\t@temp"));   
	    }
	}
	
            #my $si3fparm = $semStack[$semStackIndex-3]."FPARAMETER";
	    printTuple($semStack[$semStackIndex],"FPARAMETER",$semStack[$semStackIndex-1],"-");
	
	
	for(1..6)
	{
	pop @semStack;
	}
	push (@semStack, "fparmlist-");
	
    }
    
    
    if($redNum==27)
    {
       print ("Prod $redNum \n");
       $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab;
	$localSTLen = scalar @localST;
    
	if($procFlag==0)
	{
	    $symTab[$symTabLen][0]=$semStack[$semStackIndex];
	    $symTab[$symTabLen][1]=$semStack[$semStackIndex-4];
	    $symTab[$symTabLen][2]="matrix";
	    $symTab[$symTabLen][3]=$semStack[$semStackIndex-3];
	    $symTab[$symTabLen][4]=$semStack[$semStackIndex-1];
	    if($flags[15]==1)
	    {
		push (@outputLines, "\t\t\t\t\t\tJust entered, variable table entry: ");
                
		my @temp;
                for($j=0; $j<5; $j++)
		{
		    push (@temp, "$symTab[$symTabLen][$j] |");
		}
		push (@outputLines, join(' ', "\t\t\t\t\t\t@temp"));   
	    }
	}
	else
	{
	    $localST[$localSTLen][0]=$semStack[$semStackIndex];
	    $localST[$localSTLen][1]=$semStack[$semStackIndex-4];
	    $localST[$localSTLen][2]="matrix";
	    $localST[$localSTLen][3]=$semStack[$semStackIndex-3];
	    $localST[$localSTLen][4]=$semStack[$semStackIndex-1];
	    if($flags[15]==1)
	    {
		push (@outputLines, "\t\t\t\t\t\tJust entered, variable table entry: ");
                
		my @temp;
                for($j=0; $j<5; $j++)
		{
		    push (@temp, "$localST[$localSTLen][$j] |");
		}
                
		push (@outputLines, join(' ', "\t\t\t\t\t\t@temp"));
	    }
	}
	#my $si5fparm = $semStack[$semStackIndex-5]."FPARAMETER";
        printTuple($semStack[$semStackIndex],"FPARAMETER",$semStack[$semStackIndex-3],$semStack[$semStackIndex-1]);
	
	
	for(1..8)
	{
	    pop @semStack;
	}
	push (@semStack, "fparmlist-");
	
    }
    
    
    if($redNum==28)
    {
       print ("Prod $redNum \n");
       $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab;
	$localSTLen = scalar @localST;
	
	if($procFlag==0)
	{
	    $symTab[$symTabLen][0]=$semStack[$semStackIndex];
	    $symTab[$symTabLen][1]=$semStack[$semStackIndex-1];
	    $symTab[$symTabLen][2]="scalar";
	    $symTab[$symTabLen][3]="null";
	    $symTab[$symTabLen][4]="null";
	    
	    if($flags[15]==1)
	    {
		push (@outputLines, "\t\t\t\t\t\tJust entered, variable table entry: ");
                
		my @temp;
                for($j=0; $j<5; $j++)
		{
		    push (@temp, "$symTab[$symTabLen][$j] |");
		}
		push (@outputLines, join(' ', "\t\t\t\t\t\t@temp"));   
	    }
	}
	else
	{
	    $localST[$localSTLen][0]=$semStack[$semStackIndex];
	    $localST[$localSTLen][1]=$semStack[$semStackIndex-1];
	    $localST[$localSTLen][2]="scalar";
	    $localST[$localSTLen][3]="-";
	    $localST[$localSTLen][4]="-";
	    if($flags[15]==1)
	    {
		push (@outputLines, "\t\t\t\t\t\tJust entered, variable table entry: ");
                
		my @temp;
                for($j=0; $j<5; $j++)
		{
		    push (@temp, "$localST[$localSTLen][$j] |");
		}
		push (@outputLines, join(' ', "\t\t\t\t\t\t@temp"));   
	    }
	}
	
            printTuple("-","BEGINPARAMETERLIST","-","-");
            #my $si2fparm = $semStack[$semStackIndex-2]."FPARAMETER";
	    printTuple($semStack[$semStackIndex],"FPARAMETER","-","-");
	    
	
	for(1..5)
	{
	pop @semStack;
	}
	push (@semStack, "fparmlist-");
    }
    
     if($redNum==29)
    {
       print ("Prod $redNum \n");
       $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab;
	$localSTLen = scalar @localST;
	
	if($procFlag==0)
	{
	    $symTab[$symTabLen][0]=$semStack[$semStackIndex];
	    $symTab[$symTabLen][1]= $semStack[$semStackIndex-2];
	    $symTab[$symTabLen][2]="vector";
	    $symTab[$symTabLen][3]=$semStack[$semStackIndex-1];
	    $symTab[$symTabLen][4]="null";
	    
	    if($flags[15]==1)
	    {
		push (@outputLines, "\t\t\t\t\t\tJust entered, variable table entry: ");
                
		my @temp;
                for($j=0; $j<5; $j++)
		{
		    push (@temp, "$symTab[$symTabLen][$j] |");
		}
		push (@outputLines, join(' ', "\t\t\t\t\t\t@temp"));   
	    }
	}
	else
	{
	    $localST[$localSTLen][0]=$semStack[$semStackIndex];
	    $localST[$localSTLen][1]= $semStack[$semStackIndex-2];
	    $localST[$localSTLen][2]="vector";
	    $localST[$localSTLen][3]=$semStack[$semStackIndex-1];
	    $localST[$localSTLen][4]="null"; 
	    if($flags[15]==1)
	    {
		push (@outputLines, "\t\t\t\t\t\tJust entered, variable table entry: ");
                
		my @temp;
                for($j=0; $j<5; $j++)
		{
		    push (@temp, "$localST[$localSTLen][$j] |");
		}
		push (@outputLines, join(' ', "\t\t\t\t\t\t@temp"));   
	    }
	}
	
            printTuple("-","BEGINPARAMETERLIST","-","-");
            #my $si3fparm = $semStack[$semStackIndex-3]."FPARAMETER";
	    printTuple($semStack[$semStackIndex],"FPARAMETER",$semStack[$semStackIndex-1],"-");
	    
	
	for(1..5)
	{
	pop @semStack;
	}
	push (@semStack, "fparmlist-");
    }
    
        if($redNum==30)
        {
       print ("Prod $redNum \n");
       $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab;
	$localSTLen = scalar @localST;
    
	if($procFlag==0)
	{
	    $symTab[$symTabLen][0]=$semStack[$semStackIndex];
	    $symTab[$symTabLen][1]=$semStack[$semStackIndex-4];
	    $symTab[$symTabLen][2]="matrix";
	    $symTab[$symTabLen][3]=$semStack[$semStackIndex-3];
	    $symTab[$symTabLen][4]=$semStack[$semStackIndex-1];
	    
	    if($flags[15]==1)
	    {
		push (@outputLines, "\t\t\t\t\t\tJust entered, variable table entry: ");
                
		my @temp;
                for($j=0; $j<5; $j++)
		{
		    push (@temp, "$symTab[$symTabLen][$j] |");
		}
		push (@outputLines, join(' ', "\t\t\t\t\t\t@temp"));   
	    }
	}
	else
	{
	    $localST[$localSTLen][0]=$semStack[$semStackIndex];
	    $localST[$localSTLen][1]=$semStack[$semStackIndex-4];
	    $localST[$localSTLen][2]="matrix";
	    $localST[$localSTLen][3]=$semStack[$semStackIndex-3];
	    $localST[$localSTLen][4]=$semStack[$semStackIndex-1];
	    if($flags[15]==1)
	    {
		push (@outputLines, "\t\t\t\t\t\tJust entered, variable table entry: ");
                
		my @temp;
                for($j=0; $j<5; $j++)
		{
		    push (@temp, "$localST[$localSTLen][$j] |");
		}
		push (@outputLines, join(' ', "\t\t\t\t\t\t@temp"));   
	    }
	}
            printTyple("-","BEGINPARAMETERLIST","-","-");
            #my $si5fparm = $semStack[$semStackIndex-5]."fparameter";
	    printTuple($semStack[$semStackIndex],"FPARAMETER",$semStack[$semStackIndex-3],$semStack[$semStackIndex-1]);
	for(1..7)
	{
	pop @semStack;
	}
	push (@semStack, "fparmlist-");
    }
    
     if($redNum==31)
    {
	print ("Prod $redNum \n");
	pop @semStack;
	push (@semStack,"val");
	      
    }
    if($redNum==32)
    {
	print ("Prod $redNum \n");
	pop @semStack;
	push (@semStack,"ref");
	      
    }
    #######################################################################################

    if($redNum==33)
    {
        print ("Prod $redNum \n");
        printTuple("-","ENDOFEXECUTION","-","-");
        for(1..3)
                {
                    pop @semStack;
                }
                push (@semStack, "execpart");
    }  
    
    if($redNum==34)
    {
        print ("Prod $redNum \n");
        printTuple("MAIN","LABEL","-","-");
        printTuple("-","BEGINEXECUTION","-","-");
        pop @semStack;getSemStackTop();
	push (@semStack, "COMPUTE");getSemStackTop();
    }
        
    if($redNum==35)
    {
        print ("Prod $redNum \n");
        #pop @semStack;
        #push(@semStack, "statlist");
    }
    

    if($redNum==36)
    {
        print ("Prod $redNum \n");
        #for(1..2)
        #{
           pop @semStack;
        #}
        #push(@semStack, "statlist-");
    }
    if($redNum==37)
    {
        print ("Prod $redNum \n");
        #pop @semStack;
        #push(@semStack, "statlist-");
    }
    
    
    if($redNum==38||$redNum==39||$redNum==40||$redNum==41||$redNum==42||$redNum==43)
    {
        print ("Prod $redNum \n");
        #for(1..2)
        #{
            pop @semStack;
        #}
        #push(@semStack, "stat");
    }
 
 
    if($redNum==44)
    {
        print ("Prod $redNum \n");
        printTuple("-","ENDACTUALPARAMETER","-","-");
        pop @semStack;
        push(@semStack, "instat");
    }
    
    
 if($redNum==45)
    {
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; my $symTabIndex = $symTabLen-1;
	$localSTLen= scalar @localST; my $localSTIndex = $localSTLen-1;
        
        $semStack[$semStackIndex] = replaceVar($semStack[$semStackIndex]);
        if($notDecl==1)
        {
            push (@outputLines, "\t\t\t\t\t\tERROR: Variable $semStack[$semStackIndex] not declared.\n");
            print ("\t\t\t\t\t\tERROR: Variable $semStack[$semStackIndex] not declared.\n");
        }
        elsif($notDecl==0)
        {
        my ($tup00,$tup01,$tup02,$tup03,$tup04) = returnLoc($semStack[$semStackIndex]);
        printTuple("-","ACTUALPARAMETER",$tup00,"-");
        } #not declared ends
        for(1..2)
        {
            pop @semStack;
        }
        push (@semStack, "instat-");
    }
    
    if($redNum==46)
    {
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; my $symTabIndex = $symTabLen-1;
	$localSTLen= scalar @localST; my $localSTIndex = $localSTLen-1;
        
        $semStack[$semStackIndex-3] = replaceVar($semStack[$semStackIndex-3]);
        if($notDecl==1)
        {
            push (@outputLines, "\t\t\t\t\t\tERROR: Variable not declared.\n");
            print ("\t\t\t\t\t\tERROR: Variable not declared.\n");
        }
        else
        {
        my $realchk1 = checkSubscript($semStack[$semStackIndex-1]);
        
        if($realchk1 == 1)
        {
            push (@outputLines, "\t\t\t\t\t\tERROR: Subscripts cannot be real.\n");
            print ("\t\t\t\t\t\tERROR: Subscripts cannot be real.\n");
        }
        else
        {
            my ($tup30,$tup31,$tup32,$tup33,$tup34) = returnLoc($semStack[$semStackIndex-3]);
            my ($tup10,$tup11,$tup12,$tup13,$tup14) = returnLoc($semStack[$semStackIndex-1]);
            printTuple("-","ACTUALPARAMETER",$tup30,$tup10);
        }
        }  #notDecl ends 
        
        for(1..5)
        {
            pop @semStack;
        }
        push (@semStack, "instat-");
    }
    
    
    if($redNum==47)
    {
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; my $symTabIndex = $symTabLen-1;
	$localSTLen= scalar @localST; my $localSTIndex = $localSTLen-1;
        
        $semStack[$semStackIndex-5] = replaceVar($semStack[$semStackIndex-5]);
        
        my $realchk1 = checkSubscript($semStack[$semStackIndex-3]);
        my $realchk2 = checkSubscript($semStack[$semStackIndex-1]);
        
        if($realchk1 == 1 || $realchk2 == 1)
        {
            push (@outputLines, "\t\t\t\t\t\tERROR: Subscripts cannot be real.\n");
        }
        else
        {
            my ($tup50,$tup51,$tup52,$tup53,$tup54) = returnLoc($semStack[$semStackIndex-5]);
            my ($tup30,$tup31,$tup32,$tup33,$tup34) = returnLoc($semStack[$semStackIndex-3]);
            my ($tup10,$tup11,$tup12,$tup13,$tup14) = returnLoc($semStack[$semStackIndex-1]);
            my $irn0 = "I\$".$irn; $irn++;
            my $irn1 = "I\$".$irn; $irn++;
            #push (@outputLines, "\t\t\t\t\t\t Tuple after reduction ".$redNum." is (READPROCEDURECALL,BEGINACTUALPARAMETERS,-,-)\n");            
            printTuple($irn0,"IMULT",$tup30,$tup54);
            printTuple($irn1,"IADD",$irn0,$tup10);
            printTuple("-","ACTUALPARAMETER",$tup50,$irn1);
            
        
        for(1..7)
        {
            pop @semStack;
        }
        push (@semStack, "instat-");
        }
    }
    
    
    
    if($redNum==48)
    {
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; my $symTabIndex = $symTabLen-1;
	$localSTLen= scalar @localST; my $localSTIndex = $localSTLen-1;
        
        $semStack[$semStackIndex] = replaceVar($semStack[$semStackIndex]);
        if($notDecl==1)
        {
            push (@outputLines, "\t\t\t\t\t\tERROR: Variable $semStack[$semStackIndex] not declared.\n");
            print ("\t\t\t\t\t\tERROR: Variable $semStack[$semStackIndex] not declared.\n");
        }
        elsif($notDecl==0)
        {
        my ($tup00,$tup01,$tup02,$tup03,$tup04) = returnLoc($semStack[$semStackIndex]);
            printTuple("READ","PROCEDURECALL","-","-");
                
            
        printTuple("-","ACTUALPARAMETER",$tup00,"-");
        } #not declared ends
        for(1..2)
        {
            pop @semStack;
        }
        push (@semStack, "instat-");
    }
    
    if($redNum==49)
    {
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; my $symTabIndex = $symTabLen-1;
	$localSTLen= scalar @localST; my $localSTIndex = $localSTLen-1;
        
        $semStack[$semStackIndex-3] = replaceVar($semStack[$semStackIndex-3]);
        if($notDecl==1)
        {
            push (@outputLines, "\t\t\t\t\t\tERROR: Variable not declared.\n");
            print ("\t\t\t\t\t\tERROR: Variable not declared.\n");
        }
        else
        {
        my $realchk1 = checkSubscript($semStack[$semStackIndex-1]);
        
        if($realchk1 == 1)
        {
            push (@outputLines, "\t\t\t\t\t\tERROR: Subscripts cannot be real.\n");
            print ("\t\t\t\t\t\tERROR: Subscripts cannot be real.\n");
        }
        else
        {
            my ($tup30,$tup31,$tup32,$tup33,$tup34) = returnLoc($semStack[$semStackIndex-3]);
            my ($tup10,$tup11,$tup12,$tup13,$tup14) = returnLoc($semStack[$semStackIndex-1]);
            printTuple("READ","PROCEDURECALL","-","-");
            printTuple("-","ACTUALPARAMETER",$tup30,$tup10);
            
        }
        }#not decl ends
        for(1..5)
        {
            pop @semStack;
        }
        push (@semStack, "instat-");
    }
    
    
    if($redNum==50)
    {
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; my $symTabIndex = $symTabLen-1;
	$localSTLen= scalar @localST; my $localSTIndex = $localSTLen-1;
        
        $semStack[$semStackIndex-5] = replaceVar($semStack[$semStackIndex-5]);
        
        my $realchk1 = checkSubscript($semStack[$semStackIndex-3]);
        my $realchk2 = checkSubscript($semStack[$semStackIndex-1]);
        
        if($realchk1 == 1 || $realchk2 == 1)
        {
            push (@outputLines, "\t\t\t\t\t\tERROR: Subscripts cannot be real.\n");
        }
        else
        {
            my ($tup50,$tup51,$tup52,$tup53,$tup54) = returnLoc($semStack[$semStackIndex-5]);
            my ($tup30,$tup31,$tup32,$tup33,$tup34) = returnLoc($semStack[$semStackIndex-3]);
            my ($tup10,$tup11,$tup12,$tup13,$tup14) = returnLoc($semStack[$semStackIndex-1]);
            my $irn0 = "I\$".$irn; $irn++;
            my $irn1 = "I\$".$irn; $irn++;
             printTuple("READ","PROCEDURECALL","-","-");
            printTuple($irn0,"IMULT",$tup30,$tup54);
            printTuple($irn1,"IADD",$irn0,$tup10);
            printTuple("-","ACTUALPARAMETER",$tup50,$irn1);
            
        
        for(1..7)
        {
            pop @semStack;
        }
        push (@semStack, "instat-");
        }
    }
    
    if($redNum==51)
    {
      print ("Prod $redNum \n");
      printTuple("-","ENDACTUALPARAMETER","-","-");
      pop @semStack;
      push (@semStack,"outstat");
      
    }
    
    
    if($redNum==52)
    {
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; my $symTabIndex = $symTabLen-1;
	$localSTLen= scalar @localST; my $localSTIndex = $localSTLen-1;
        
        $semStack[$semStackIndex] = replaceVar($semStack[$semStackIndex]);
        if($notDecl==1)
        {
            push (@outputLines, "\t\t\t\t\t\tERROR: Variable $semStack[$semStackIndex] not declared.\n");
            print ("\t\t\t\t\t\tERROR: Variable $semStack[$semStackIndex] not declared.\n");
        }
        elsif($notDecl==0)
        {
        my ($tup00,$tup01,$tup02,$tup03,$tup04) = returnLoc($semStack[$semStackIndex]);
        printTuple("-","ACTUALPARAMETER",$tup00,"-");
        } #not declared ends
        for(1..2)
        {
            pop @semStack;
        }
        push (@semStack, "outstat-");
    }
    
    if($redNum==53)
    {
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; my $symTabIndex = $symTabLen-1;
	$localSTLen= scalar @localST; my $localSTIndex = $localSTLen-1;
        
        $semStack[$semStackIndex-3] = replaceVar($semStack[$semStackIndex-3]);
        if($notDecl==1)
        {
            push (@outputLines, "\t\t\t\t\t\tERROR: Variable not declared.\n");
            print ("\t\t\t\t\t\tERROR: Variable not declared.\n");
        }
        else
        {
        my $realchk1 = checkSubscript($semStack[$semStackIndex-1]);
        
        if($realchk1 == 1)
        {
            push (@outputLines, "\t\t\t\t\t\tERROR: Subscripts cannot be real.\n");
            print ("\t\t\t\t\t\tERROR: Subscripts cannot be real.\n");
        }
        else
        {
            my ($tup50,$tup51,$tup52,$tup53,$tup54) = returnLoc($semStack[$semStackIndex-5]);
            my ($tup30,$tup31,$tup32,$tup33,$tup34) = returnLoc($semStack[$semStackIndex-3]);
            my ($tup10,$tup11,$tup12,$tup13,$tup14) = returnLoc($semStack[$semStackIndex-1]);
            printTuple("-","ACTUALPARAMETER",$tup30,$tup10);
        }
        }    
        
        for(1..5)
        {
            pop @semStack;
        }
        push (@semStack, "outstat-");
    }
    
    
    if($redNum==54)
    {
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; my $symTabIndex = $symTabLen-1;
	$localSTLen= scalar @localST; my $localSTIndex = $localSTLen-1;
        
        $semStack[$semStackIndex-5] = replaceVar($semStack[$semStackIndex-5]);
        if($notDecl==1)
        {
            push (@outputLines, "\t\t\t\t\t\tERROR: Variable $semStack[$semStackIndex-5] not declared.\n");
            print ("\t\t\t\t\t\tERROR: Variable $semStack[$semStackIndex-5] not declared.\n");
        }
        else
        {
        my $realchk1 = checkSubscript($semStack[$semStackIndex-3]);
        my $realchk2 = checkSubscript($semStack[$semStackIndex-1]);
        
        if($realchk1 == 1 || $realchk2 == 1)
        {
            push (@outputLines, "\t\t\t\t\t\tERROR: Subscripts cannot be real.\n");
        }
        else
        {
            my ($tup50,$tup51,$tup52,$tup53,$tup54) = returnLoc($semStack[$semStackIndex-5]);
            my ($tup30,$tup31,$tup32,$tup33,$tup34) = returnLoc($semStack[$semStackIndex-3]);
            my ($tup10,$tup11,$tup12,$tup13,$tup14) = returnLoc($semStack[$semStackIndex-1]);
            my $irn0 = "I\$".$irn; $irn++;
            my $irn1 = "I\$".$irn; $irn++;
            
            printTuple($irn0,"IMULT",$tup30,$tup54);
            printTuple($irn1,"IADD",$irn0,$tup10);
            printTuple("-","ACTUALPARAMETER",$tup50,$irn1);
        }
        }    
        
        for(1..7)
        {
            pop @semStack;
        }
        push (@semStack, "outstat-");
    }
    
    
    
    if($redNum==55)
    {
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; my $symTabIndex = $symTabLen-1;
	$localSTLen= scalar @localST; my $localSTIndex = $localSTLen-1;
        
        $semStack[$semStackIndex] = replaceVar($semStack[$semStackIndex]);
        if($notDecl==1)
        {
            push (@outputLines, "\t\t\t\t\t\tERROR: Variable $semStack[$semStackIndex] not declared.\n");
            print ("\t\t\t\t\t\tERROR: Variable $semStack[$semStackIndex] not declared.\n");
        }
        elsif($notDecl==0)
        {
        my ($tup00,$tup01,$tup02,$tup03,$tup04) = returnLoc($semStack[$semStackIndex]);
            printTuple("PRINT","PROCEDURECALL","-","-");
        printTuple("-","ACTUALPARAMETER",$tup00,"-");
        } #not declared ends
        for(1..2)
        {
            pop @semStack;
        }
        push (@semStack, "outstat-");
    }
    
    if($redNum==56)
    {
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; my $symTabIndex = $symTabLen-1;
	$localSTLen= scalar @localST; my $localSTIndex = $localSTLen-1;
        
        $semStack[$semStackIndex-3] = replaceVar($semStack[$semStackIndex-3]);
        if($notDecl==1)
        {
            push (@outputLines, "\t\t\t\t\t\tERROR: Variable $semStack[$semStackIndex-3] not declared.\n");
            print ("\t\t\t\t\t\tERROR: Variable $semStack[$semStackIndex-3] not declared.\n");
        }
        else
        {
        my $realchk1 = checkSubscript($semStack[$semStackIndex-1]);
        
        if($realchk1 == 1)
        {
            push (@outputLines, "\t\t\t\t\t\tERROR: Subscripts cannot be real.\n");
            print ("\t\t\t\t\t\tERROR: Subscripts cannot be real.\n");
        }
        else
        {
            my ($tup30,$tup31,$tup32,$tup33,$tup34) = returnLoc($semStack[$semStackIndex-3]);
            my ($tup10,$tup11,$tup12,$tup13,$tup14) = returnLoc($semStack[$semStackIndex-1]);
            
                printTuple("PRINT","PROCEDURECALL","-","-");
            
            printTuple("-","ACTUALPARAMETER",$tup30,$tup10);
        }
        }
        for(1..5)
        {
            pop @semStack;
        }
        push (@semStack, "outstat-");
    }
    
    
    if($redNum==57)
    {
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; my $symTabIndex = $symTabLen-1;
	$localSTLen= scalar @localST; my $localSTIndex = $localSTLen-1;
        
        $semStack[$semStackIndex-5] = replaceVar($semStack[$semStackIndex-5]);
        if($notDecl==1)
        {
            push (@outputLines, "\t\t\t\t\t\tERROR: Variable $semStack[$semStackIndex-5] not declared.\n");
            print ("\t\t\t\t\t\tERROR: Variable $semStack[$semStackIndex-5] not declared.\n");
        }
        else
        {
        my $realchk1 = checkSubscript($semStack[$semStackIndex-3]);
        my $realchk2 = checkSubscript($semStack[$semStackIndex-1]);
        
        if($realchk1 == 1 || $realchk2 == 1)
        {
            push (@outputLines, "\t\t\t\t\t\tERROR: Subscripts cannot be real.\n");
        }
        else
        {
            my ($tup50,$tup51,$tup52,$tup53,$tup54) = returnLoc($semStack[$semStackIndex-5]);
            my ($tup30,$tup31,$tup32,$tup33,$tup34) = returnLoc($semStack[$semStackIndex-3]);
            my ($tup10,$tup11,$tup12,$tup13,$tup14) = returnLoc($semStack[$semStackIndex-1]);
            my $irn0 = "I\$".$irn; $irn++;
            my $irn1 = "I\$".$irn; $irn++;
             printTuple("PRINT","PROCEDURECALL","-","-");
            
            printTuple($irn0,"IMULT",$tup30,$tup54);
            printTuple($irn1,"IADD",$irn0,$tup10);
            printTuple("-","ACTUALPARAMETER",$tup50,$irn1);
        }
        }    
        
        for(1..7)
        {
            pop @semStack;
        }
        push (@semStack, "outstat-");
        
    }
    
    if($redNum==58)    ###check this###
    {
        print ("Prod $redNum \n");
        printTuple("-","ENDOFCALL","-","-");
        pop @semStack;        
        push (@semStack, "callstat");
    }
    
    
    if($redNum==59)
    {
        print ("Prod $redNum \n");
        printTuple("-","ENDOFCALL","-","-");
        
        for(1..2)
        {
            pop @semStack;
        }
        push (@semStack, "callstat");
    }
    
    
    if($redNum==60)
    {
        print ("Prod $redNum \n");
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; my $symTabIndex = $symTabLen-1;
	$localSTLen= scalar @localST; my $localSTIndex = $localSTLen-1;
        
        $semStack[$semStackIndex] = replaceVar($semStack[$semStackIndex]);
        
        if($notDecl==1)
        {
            push (@outputLines, "\t\t\t\t\t\tERROR: Variable $semStack[$semStackIndex] not declared.\n");
            print ("\t\t\t\t\t\tERROR: Variable $semStack[$semStackIndex] not declared.\n");
        }
        elsif($notDecl==0)
        {
        my ($tup00, $tup01, $tup02, $tup03, $tup04) = returnLoc($semStack[$semStackIndex]);
        
        
        printTuple($tup00,"PROCEDURECALL","-","-");
        }#not Decl ends
        for(1..2)
        {
            pop @semStack;
        }
        push (@semStack, "callname");
        
       
    }
    
    if($redNum==61)
    {
        print ("Prod $redNum \n");
        
	printTuple("-","ENDPARAMETERLIST","-","-");
        
                for(1..2)
                {
                    pop @semStack;
                }
                push (@semStack, "aparmlist");
    }
    
    if($redNum==62)
    {
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; my $symTabIndex = $symTabLen-1;
	$localSTLen= scalar @localST; my $localSTIndex = $localSTLen-1;
        
        $semStack[$semStackIndex] = replaceVar($semStack[$semStackIndex]);
        if($notDecl==1)
        {
            push (@outputLines, "\t\t\t\t\t\tERROR: Variable $semStack[$semStackIndex] not declared.\n");
            print ("\t\t\t\t\t\tERROR: Variable $semStack[$semStackIndex] not declared.\n");
        }
        elsif($notDecl==0)
        {
        my ($tup00,$tup01,$tup02,$tup03,$tup04) = returnLoc($semStack[$semStackIndex]);
           
        printTuple($semStack[$semStackIndex-1],"ACTUALPARAMETER",$tup00,"-");
        my $subpara = $semStack[$semStackIndex-1]."ACTUALPARAMETER";
            printTuple("-",$subpara,$tup00,"-");
        } #not declared ends
        for(1..3)
        {
            pop @semStack;
        }
        
    }
    
    if($redNum==63)
    {
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; my $symTabIndex = $symTabLen-1;
	$localSTLen= scalar @localST; my $localSTIndex = $localSTLen-1;
        
        $semStack[$semStackIndex-3] = replaceVar($semStack[$semStackIndex-3]);
        if($notDecl==1)
        {
            push (@outputLines, "\t\t\t\t\t\tERROR: Variable $semStack[$semStackIndex-3] not declared.\n");
            print ("\t\t\t\t\t\tERROR: Variable $semStack[$semStackIndex-3] not declared.\n");
        }
        else
        {
        my $realchk1 = checkSubscript($semStack[$semStackIndex-1]);
        
        if($realchk1 == 1)
        {
            push (@outputLines, "\t\t\t\t\t\tERROR: Subscripts cannot be real.\n");
            print ("\t\t\t\t\t\tERROR: Subscripts cannot be real.\n");
        }
        else
        {
            my ($tup30,$tup31,$tup32,$tup33,$tup34) = returnLoc($semStack[$semStackIndex-3]);
            my ($tup10,$tup11,$tup12,$tup13,$tup14) = returnLoc($semStack[$semStackIndex-1]);
            
            printTuple($semStack[$semStackIndex-4],"ACTUALPARAMETER",$tup30,$tup10);
            my $subpara = $semStack[$semStackIndex-4]."ACTUALPARAMETER";
            printTuple("-",$subpara,$tup30,$tup10);
        }
        }
        for(1..6)
        {
            pop @semStack;
        }
        
    }
    
    
    if($redNum==64)
    {
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; my $symTabIndex = $symTabLen-1;
	$localSTLen= scalar @localST; my $localSTIndex = $localSTLen-1;
        
        $semStack[$semStackIndex-5] = replaceVar($semStack[$semStackIndex-5]);
        if($notDecl==1)
        {
            push (@outputLines, "\t\t\t\t\t\tERROR: Variable $semStack[$semStackIndex-5] not declared.\n");
            print ("\t\t\t\t\t\tERROR: Variable $semStack[$semStackIndex-5] not declared.\n");
        }
        else
        {
        my $realchk1 = checkSubscript($semStack[$semStackIndex-3]);
        my $realchk2 = checkSubscript($semStack[$semStackIndex-1]);
        
        if($realchk1 == 1 || $realchk2 == 1)
        {
            push (@outputLines, "\t\t\t\t\t\tERROR: Subscripts cannot be real.\n");
        }
        else
        {
            my ($tup50,$tup51,$tup52,$tup53,$tup54) = returnLoc($semStack[$semStackIndex-5]);
            my ($tup30,$tup31,$tup32,$tup33,$tup34) = returnLoc($semStack[$semStackIndex-3]);
            my ($tup10,$tup11,$tup12,$tup13,$tup14) = returnLoc($semStack[$semStackIndex-1]);
            my $irn0 = "I\$".$irn; $irn++;
            my $irn1 = "I\$".$irn; $irn++;
            if($flags[13] ==1)
            {
                #push (@outputLines, "\t\t\t\t\t\t Tuple after reduction ".$redNum." is (-,BEGINACTUALPARAMETERS,-,-)\n");
                
            }
            push (@ftupleOutput, "-,BEGINACTUALPARAMETERS,-,-)\n");
            printTuple($irn0,"IMULT",$tup30,$tup54);
            printTuple($irn1,"IADD",$irn0,$tup10);
            printTuple($semStack[$semStackIndex-6],"ACTUALPARAMETER",$tup50,$irn1);
            my $subpara = $semStack[$semStackIndex-6]."ACTUALPARAMETER";
            printTuple("-",$subpara,$tup50,$irn1);
        }
        }    
        
        for(1..8)
        {
            pop @semStack;
        }
        
    }
    
    
    
    if($redNum==65)
    {
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; my $symTabIndex = $symTabLen-1;
	$localSTLen= scalar @localST; my $localSTIndex = $localSTLen-1;
        
        $semStack[$semStackIndex] = replaceVar($semStack[$semStackIndex]);
        if($notDecl==1)
        {
            push (@outputLines, "\t\t\t\t\t\tERROR: Variable $semStack[$semStackIndex] not declared.\n");
            print ("\t\t\t\t\t\tERROR: Variable $semStack[$semStackIndex] not declared.\n");
        }
        elsif($notDecl==0)
        {
        my ($tup00,$tup01,$tup02,$tup03,$tup04) = returnLoc($semStack[$semStackIndex]);
            
                printTuple("-","BEGINACTUALPARAMETERS","-","-");
                
            
        printTuple($semStack[$semStackIndex-1],"ACTUALPARAMETER",$tup00,"-");
        my $subpara = $semStack[$semStackIndex-1]."ACTUALPARAMETER";
        printTuple("-",$subpara,$tup00,"-");
        } #not declared ends
        for(1..3)
        {
            pop @semStack;
        }
        
    }
    
    if($redNum==66)
    {
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; my $symTabIndex = $symTabLen-1;
	$localSTLen= scalar @localST; my $localSTIndex = $localSTLen-1;
        
        $semStack[$semStackIndex-3] = replaceVar($semStack[$semStackIndex-3]);
        if($notDecl==1)
        {
            push (@outputLines, "\t\t\t\t\t\tERROR: Variable $semStack[$semStackIndex-3] not declared.\n");
            print ("\t\t\t\t\t\tERROR: Variable $semStack[$semStackIndex-3] not declared.\n");
        }
        else
        {
        my $realchk1 = checkSubscript($semStack[$semStackIndex-1]);
        
        if($realchk1 == 1)
        {
            push (@outputLines, "\t\t\t\t\t\tERROR: Subscripts cannot be real.\n");
            print ("\t\t\t\t\t\tERROR: Subscripts cannot be real.\n");
        }
        else
        {
            my ($tup30,$tup31,$tup32,$tup33,$tup34) = returnLoc($semStack[$semStackIndex-3]);
            my ($tup10,$tup11,$tup12,$tup13,$tup14) = returnLoc($semStack[$semStackIndex-1]);
            if($flags[13] ==1)
            {
                push (@outputLines, "\t\t\t\t\t\t Tuple after reduction ".$redNum." is (-,BEGINACTUALPARAMETERS,-,-)\n");
                
            }
            push (@ftupleOutput, "-,BEGINACTUALPARAMETERS,-,-)\n");
            printTuple($semStack[$semStackIndex-4],"ACTUALPARAMETER",$tup30,$tup10);
            my $subpara = $semStack[$semStackIndex-4]."ACTUALPARAMETER";
            printTuple("-",$subpara,$tup30,$tup10);
        }
        }
        for(1..6)
        {
            pop @semStack;
        }
        
    }
    
    
    if($redNum==67)
    {
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; my $symTabIndex = $symTabLen-1;
	$localSTLen= scalar @localST; my $localSTIndex = $localSTLen-1;
        
        $semStack[$semStackIndex-5] = replaceVar($semStack[$semStackIndex-5]);
        if($notDecl==1)
        {
            push (@outputLines, "\t\t\t\t\t\tERROR: Variable $semStack[$semStackIndex-5] not declared.\n");
            print ("\t\t\t\t\t\tERROR: Variable $semStack[$semStackIndex-5] not declared.\n");
        }
        else
        {
        my $realchk1 = checkSubscript($semStack[$semStackIndex-3]);
        my $realchk2 = checkSubscript($semStack[$semStackIndex-1]);
        
        if($realchk1 == 1 || $realchk2 == 1)
        {
            push (@outputLines, "\t\t\t\t\t\tERROR: Subscripts cannot be real.\n");
        }
        else
        {
            my ($tup50,$tup51,$tup52,$tup53,$tup54) = returnLoc($semStack[$semStackIndex-5]);
            my ($tup30,$tup31,$tup32,$tup33,$tup34) = returnLoc($semStack[$semStackIndex-3]);
            my ($tup10,$tup11,$tup12,$tup13,$tup14) = returnLoc($semStack[$semStackIndex-1]);
            my $irn0 = "I\$".$irn; $irn++;
            my $irn1 = "I\$".$irn; $irn++;
            printTuple("-","BEGINACTUALPARAMETERS","-","-");
            printTuple($irn0,"IMULT",$tup30,$tup54);
            printTuple($irn1,"IADD",$irn0,$tup10);
            printTuple($semStack[$semStackIndex-6],"ACTUALPARAMETER",$tup50,$irn1);
            my $subpara = $semStack[$semStackIndex-6]."ACTUALPARAMETER";
            printTuple("-",$subpara,$tup50,$irn1);
        }
        }    
        
        for(1..8)
        {
            pop @semStack;
        }
        
    }
    
    
    if($redNum==68)
    {
        print ("Prod $redNum\n");
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; 
	$localSTLen= scalar @localST;
        
        printTuple($semStack[$semStackIndex-2],"LABEL","-","-");
        
        for(1..2)
        {
            pop @semStack;
        }
    }
    
    if($redNum==69)
    {
        print ("Prod $redNum\n");
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; 
	$localSTLen= scalar @localST;
        my $label1no = substr($semStack[$semStackIndex-2],2);
        my $labincr = ++$label1no;
        my $label1= "L\$".$labincr;
        printTuple($label1,"LABEL","-","-");
        
        for(1..2)
        {
            pop @semStack;
        }
    }
    
    
    if($redNum==70)
    {
        print ("Prod $redNum\n");
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; 
	$localSTLen= scalar @localST;
        
        
        my $label1no = substr($semStack[$semStackIndex-2],2);
        my $labincr = ++$label1no;
        my $label1= "L\$".$labincr;
        printTuple($label1 ,"JUMP","-","-");
        
        printTuple($semStack[$semStackIndex-2],"LABEL","-","-");

        pop @semStack;
        pop @semStack;
        
    } 
    
    if($redNum==71)
    {
        print ("Prod $redNum\n");
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; 
	$localSTLen= scalar @localST;
    
        my $label1 = "L\$".$label;$label++;
        #my $label2 = "L\$".$label;$label++;
       
        printTuple($label1,"CJUMPF",$semStack[$semStackIndex-1],"-");
        for(1..3)
        {
            pop @semStack;
        }
        push (@semStack,$label1);
    }
    
    if($redNum==72)
    {
        print ("Prod $redNum\n");
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; 
	$localSTLen= scalar @localST;
        printTuple($semStack[$semStackIndex-2],"JUMP","-","-");
        my $label1no = substr($semStack[$semStackIndex-2],2);
        my $labincr = ++$label1no;
        my $label1= "L\$".$labincr;
        printTuple($label1,"LABEL","-","-");
        for(1..2)
        {
            pop @semStack;
        }
    } 
     
     
    if($redNum==73)
    {
        print ("Prod $redNum\n");
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; 
	$localSTLen= scalar @localST;
	my $label1no = substr($semStack[$semStackIndex-2],2);
        my $labincr = ++$label1no;
        my $label1= "L\$".$labincr;
        $semStack[$semStackIndex-1] = replaceVar($semStack[$semStackIndex-1]);
        printTuple($label1,"CJUMPF",$semStack[$semStackIndex-1],"-");
        for(1..2)
        {
            pop @semStack;
        }
    }
     
     
     
     
    if($redNum==74)
    {
        print ("Prod $redNum\n");
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; 
	$localSTLen= scalar @localST;
        my $label1="L\$".$label;$label++;
        my $label2="L\$".$label;$label++;
        printTuple($label1,"LABEL","-","-");
        pop @semStack;
        push (@semStack, $label1);
        
       
    }  
     
     
     
    if($redNum==75)
    {
        print ("Prod $redNum\n");
        
    }
     

     if($redNum==76)
    {
        print ("Prod $redNum\n");
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; my $symTabIndex = $symTabLen-1;
	$localSTLen= scalar @localST; my $localSTIndex = $localSTLen-1;
        
        $semStack[$semStackIndex-2] = replaceVar($semStack[$semStackIndex-2]);
        if($notDecl==1)
        {
            push (@outputLines, "\t\t\t\t\t\tERROR: Variable $semStack[$semStackIndex-2] not declared.\n");
            print ("\t\t\t\t\t\tERROR: Variable $semStack[$semStackIndex-2] not declared.\n");
        }
        elsif($notDecl==0)
        {
        my ($tup00,$tup01,$tup02,$tup03,$tup04) = returnLoc($semStack[$semStackIndex]);
        my ($tup20,$tup21,$tup22,$tup23,$tup24) = returnLoc($semStack[$semStackIndex-2]);
        if($tup21 ne $tup01)
            {
                if($tup01 eq "real")
                {   my $irn0 = "R\$".$irn; $irn++;
                    printTuple($irn0,"CONVERTIR",$tup00,"-");
                
                }
                elsif($tup01 eq "integer")
                {
                    my $irn0 = "I\$".$irn; $irn++;
                    printTuple($irn0,"CONVERTRI",$tup00,"-");
                    
                }
                #$irn++;
            }
            
        printTuple($tup20,"SUBSTORE",$tup00,"-");
        } #not declared ends
        for(1..2)
        {
            pop @semStack;
        }
        
    }
    
    if($redNum==77)
    {
        print ("Prod $redNum\n");
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; my $symTabIndex = $symTabLen-1;
	$localSTLen= scalar @localST; my $localSTIndex = $localSTLen-1;
        
        $semStack[$semStackIndex-5] = replaceVar($semStack[$semStackIndex-5]);
        if($notDecl==1)
        {
            push (@outputLines, "\t\t\t\t\t\tERROR: Variable $semStack[$semStackIndex-5] not declared.\n");
            print ("\t\t\t\t\t\tERROR: Variable $semStack[$semStackIndex-5] not declared.\n");
        }
        else
        {
        my $realchk1 = checkSubscript($semStack[$semStackIndex-3]);
        
        if($realchk1 == 1)
        {
            push (@outputLines, "\t\t\t\t\t\tERROR: Subscripts cannot be real.\n");
            print ("\t\t\t\t\t\tERROR: Subscripts cannot be real.\n");
        }
        else
        {
            my ($tup30,$tup31,$tup32,$tup33,$tup34) = returnLoc($semStack[$semStackIndex-3]);
            my ($tup50,$tup51,$tup52,$tup53,$tup54) = returnLoc($semStack[$semStackIndex-5]);
            my ($tup00,$tup01,$tup02,$tup03,$tup04) = returnLoc($semStack[$semStackIndex-0]);
            
            if($tup51 ne $tup01)
            {
                if($tup01 eq "real")
                {   my $irn0 = "R\$".$irn; $irn++;
                    printTuple($irn0,"CONVERTIR",$tup00,"-");
                
                }
                elsif($tup01 eq "integer")
                {
                    my $irn0 = "I\$".$irn; $irn++;
                    printTuple($irn0,"CONVERTRI",$tup00,"-");
                    
                }
                #$irn++;
            }
            
            printTuple($tup50,"SUBSTORE",$tup00,$tup30);
        }
        }
        for(1..5)
        {
            pop @semStack;
        }
        
    }
    
    
    if($redNum==78)
    {
        print ("Prod $redNum\n");
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; my $symTabIndex = $symTabLen-1;
	$localSTLen= scalar @localST; my $localSTIndex = $localSTLen-1;
        
        $semStack[$semStackIndex-7] = replaceVar($semStack[$semStackIndex-7]);
        if($notDecl==1)
        {
            push (@outputLines, "\t\t\t\t\t\tERROR: Variable $semStack[$semStackIndex-7] not declared.\n");
            print ("\t\t\t\t\t\tERROR: Variable $semStack[$semStackIndex-7] not declared.\n");
        }
        else
        {
        my $realchk1 = checkSubscript($semStack[$semStackIndex-3]);
        my $realchk2 = checkSubscript($semStack[$semStackIndex-5]);
        
        if($realchk1 == 1 || $realchk2 == 1)
        {
            push (@outputLines, "\t\t\t\t\t\tERROR: Subscripts cannot be real.\n");
        }
        else
        {
            my ($tup00,$tup01,$tup02,$tup03,$tup04) = returnLoc($semStack[$semStackIndex]);
            my ($tup50,$tup51,$tup52,$tup53,$tup54) = returnLoc($semStack[$semStackIndex-5]);
            my ($tup30,$tup31,$tup32,$tup33,$tup34) = returnLoc($semStack[$semStackIndex-3]);
            my ($tup70,$tup71,$tup72,$tup73,$tup74) = returnLoc($semStack[$semStackIndex-7]);
            
            my $irn1 = "I\$".$irn; $irn++;
            my $irn2 = "I\$".$irn; $irn++;
            
            if($tup71 ne $tup01)
            {
                if($tup71 eq "real")
                {   my $irn0 = "R\$".$irn; $irn++;
                    printTuple($irn0,"CONVERTIR",$tup00,"-");
                }
                elsif($tup01 eq "integer")
                {
                    my $irn0 = "I\$".$irn; $irn++;
                    printTuple($irn0,"CONVERTRI",$tup00,"-");
                }
            }
            printTuple($irn1,"IMULT",$tup50,$tup74);
            printTuple($irn2,"IADD",$irn1,$tup30);
            printTuple($tup70,"SUBSTORE",$tup00,$irn1);
            #$irn=$irn+3;
        }
        }
        for(1..7)
        {
            pop @semStack;
        }
        
    }
 
    
    if($redNum==79)
    {
	print ("Prod $redNum \n");
    }
    
    
    if($redNum==80)
    {
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; my $symTabIndex = $symTabLen-1;
	$localSTLen= scalar @localST; my $localSTIndex = $localSTLen-1;
        
        my ($retVar0,$realchk0) = checkSubscript($semStack[$semStackIndex]);
        my $yesBoole0 = $yesBoole;
        
        my ($retVar2,$realchk2) = checkSubscript($semStack[$semStackIndex-2]);
        my $yesBoole2 = $yesBoole;
        
        if($yesBoole0!=1 || $yesBoole2!=1)
        {
            push (@outputLines, "\t\t\t\t\t\tNon boolean operand for boolean operation");
        }
        else
        {
            my $irn1 = "B\$".$irn; $irn++;
            printTuple($irn1,"OR",$retVar0,$retVar2);
                for(1..3)
                {
                    pop @semStack;
                }
                push (@semStack,$irn1);
        }
        $yesBoole = 0;
    }
    
    if($redNum==81)
    {
	print ("Prod $redNum \n");
    }
    if($redNum==82)
    {
	print ("Prod $redNum \n");
    }
    
    if($redNum==83)
    {
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; my $symTabIndex = $symTabLen-1;
	$localSTLen= scalar @localST; my $localSTIndex = $localSTLen-1;
        
        my ($retVar0,$realchk0) = checkSubscript($semStack[$semStackIndex]);
        my $yesBoole0 = $yesBoole;
        
        my ($retVar2,$realchk2) = checkSubscript($semStack[$semStackIndex-2]);
        my $yesBoole2 = $yesBoole;
        
        if($yesBoole0!=1 || $yesBoole2!=1)
        {
            push (@outputLines, "\t\t\t\t\t\tNon boolean operand for boolean operation");
        }
        else
        {
            my $irn1 = "B\$".$irn; $irn++;
            printTuple($irn1,"AND",$retVar0,$retVar2);
                for(1..3)
                {
                    pop @semStack;
                }
                push (@semStack,$irn1);
        }
        $yesBoole = 0;
    }
    

    
    if($redNum==84)
    {
	print ("Prod $redNum \n");
    }
    
    if($redNum==85)
    {
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; my $symTabIndex = $symTabLen-1;
	$localSTLen= scalar @localST; my $localSTIndex = $localSTLen-1;
        
        my ($retVar0,$realchk0) = checkSubscript($semStack[$semStackIndex]);
        if($yesBoole!=1)
        {
            push (@outputLines, "\t\t\t\t\t\tNon boolean operand for boolean operation");
        }
        else
        {
            my $irn1 = "B\$".$irn; $irn++;
            printTuple($irn1,"NOT",$retVar0,"-");
                for(1..2)
                {
                    pop @semStack;
                }
                push (@semStack,$irn1);
        }
        $yesBoole = 0;
    }
    
    
    if($redNum==86)
    {
	print ("Prod $redNum \n");    
    }
    
    
    if($redNum==87)
    {
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; my $symTabIndex = $symTabLen-1;
	$localSTLen= scalar @localST; my $localSTIndex = $localSTLen-1;
        
        my ($retVar0,$realchk0) = checkSubscript($semStack[$semStackIndex]);
        my ($retVar2,$realchk2) = checkSubscript($semStack[$semStackIndex-2]);
        
        if($realchk0 != $realchk2)
        {
            if($realchk0 == 0)
            {
                my $irn0 = "R\$".$irn; $irn++;
                printTuple($irn0,"CONVERTIR",$retVar0,"-");
            }
            elsif($realchk0==1)
            {
                my $irn0 = "I\$".$irn; $irn++;
                printTuple($irn0,"CONVERTRI",$retVar0,"-");
            }
        }
        elsif($realchk0 == $realchk2)
        {
            my $irn1 = "B\$".$irn; $irn++;
            if($realchk0 == 0)
            {
                printTuple($irn1,"IL",$retVar2,$retVar0);
            }
            elsif($realchk0 == 1)
            {
                printTuple($irn1,"RL",$retVar2,$retVar0);
            }
        
                for(1..3)
                {
                    pop @semStack;
                }
                push (@semStack,$irn1);
        }
        
    }
    
    if($redNum==88)
    {
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; my $symTabIndex = $symTabLen-1;
	$localSTLen= scalar @localST; my $localSTIndex = $localSTLen-1;
        
        my ($retVar0,$realchk0) = checkSubscript($semStack[$semStackIndex]);
        my ($retVar2,$realchk2) = checkSubscript($semStack[$semStackIndex-2]);
        
        if($realchk0 != $realchk2)
        {
            if($realchk0 == 0)
            {
                my $irn0 = "R\$".$irn; $irn++;
                printTuple($irn0,"CONVERTIR",$retVar0,"-");
            }
            elsif($realchk0==1)
            {
                my $irn0 = "I\$".$irn; $irn++;
                printTuple($irn0,"CONVERTRI",$retVar0,"-");
            }
        }
        elsif($realchk0 == $realchk2)
        {
            my $irn1 = "B\$".$irn; $irn++;
            if($realchk0 == 0)
            {
                printTuple($irn1,"ILE",$retVar2,$retVar0);
            }
            elsif($realchk0 == 1)
            {
                printTuple($irn1,"RLE",$retVar2,$retVar0);
            }
        
                for(1..3)
                {
                    pop @semStack;
                }
                push (@semStack,$irn1);
        }
        
    }
    if($redNum==89)
    {
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; my $symTabIndex = $symTabLen-1;
	$localSTLen= scalar @localST; my $localSTIndex = $localSTLen-1;
        
        my ($retVar0,$realchk0) = checkSubscript($semStack[$semStackIndex]);
        my ($retVar2,$realchk2) = checkSubscript($semStack[$semStackIndex-2]);
        
        if($realchk0 != $realchk2)
        {
            if($realchk0 == 0)
            {
                my $irn0 = "R\$".$irn; $irn++;
                printTuple($irn0,"CONVERTIR",$retVar0,"-");
            }
            elsif($realchk0==1)
            {
                my $irn0 = "I\$".$irn; $irn++;
                printTuple($irn0,"CONVERTRI",$retVar0,"-");
            }
        }
        elsif($realchk0 == $realchk2)
        {
            my $irn1 = "B\$".$irn; $irn++;
            if($realchk0 == 0)
            {
                printTuple($irn1,"IG",$retVar2,$retVar0);
            }
            elsif($realchk0 == 1)
            {
                printTuple($irn1,"RG",$retVar2,$retVar0);
            }
        
                for(1..3)
                {
                    pop @semStack;
                }
                push (@semStack,$irn1);
        }
        
    }
    
    
    if($redNum==90)
    {
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; my $symTabIndex = $symTabLen-1;
	$localSTLen= scalar @localST; my $localSTIndex = $localSTLen-1;
        
        my ($retVar0,$realchk0) = checkSubscript($semStack[$semStackIndex]);
        my ($retVar2,$realchk2) = checkSubscript($semStack[$semStackIndex-2]);
        
        if($realchk0 != $realchk2)
        {
            if($realchk0 == 0)
            {
                my $irn0 = "R\$".$irn; $irn++;
                printTuple($irn0,"CONVERTIR",$retVar0,"-");
            }
            elsif($realchk0==1)
            {
                my $irn0 = "I\$".$irn; $irn++;
                printTuple($irn0,"CONVERTRI",$retVar0,"-");
            }
        }
        elsif($realchk0 == $realchk2)
        {
            my $irn1 = "B\$".$irn; $irn++;
            if($realchk0 == 0)
            {
                printTuple($irn1,"IGE",$retVar2,$retVar0);
            }
            elsif($realchk0 == 1)
            {
                printTuple($irn1,"RGE",$retVar2,$retVar0);
            }
        
                for(1..3)
                {
                    pop @semStack;
                }
                push (@semStack,$irn1);
        }
        
    }
    if($redNum==91)
    {
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; my $symTabIndex = $symTabLen-1;
	$localSTLen= scalar @localST; my $localSTIndex = $localSTLen-1;
        
        my ($retVar0,$realchk0) = checkSubscript($semStack[$semStackIndex]);
        my ($retVar2,$realchk2) = checkSubscript($semStack[$semStackIndex-2]);
        
        if($realchk0 != $realchk2)
        {
            if($realchk0 == 0)
            {
                my $irn0 = "R\$".$irn; $irn++;
                printTuple($irn0,"CONVERTIR",$retVar0,"-");
            }
            elsif($realchk0==1)
            {
                my $irn0 = "I\$".$irn; $irn++;
                printTuple($irn0,"CONVERTRI",$retVar0,"-");
            }
        }

            my $irn1 = "B\$".$irn; $irn++;
            if($realchk0 == 0)
            {
                printTuple($irn1,"IEQ",$retVar2,$retVar0);
            }
            elsif($realchk0 == 1)
            {
                printTuple($irn1,"REQ",$retVar2,$retVar0);
            }
        
                for(1..3)
                {
                    pop @semStack;
                }
                push (@semStack,$irn1);
    }
    
    if($redNum==92)
    {
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; my $symTabIndex = $symTabLen-1;
	$localSTLen= scalar @localST; my $localSTIndex = $localSTLen-1;
        
        my ($retVar0,$realchk0) = checkSubscript($semStack[$semStackIndex]);
        my ($retVar2,$realchk2) = checkSubscript($semStack[$semStackIndex-2]);
        
        if($realchk0 != $realchk2)
        {
            if($realchk0 == 0)
            {
                my $irn0 = "R\$".$irn; $irn++;
                printTuple($irn0,"CONVERTIR",$retVar0,"-");
            }
            elsif($realchk0==1)
            {
                my $irn0 = "I\$".$irn; $irn++;
                printTuple($irn0,"CONVERTRI",$retVar0,"-");
            }
        }
        elsif($realchk0 == $realchk2)
        {
            my $irn1 = "B\$".$irn; $irn++;
            if($realchk0 == 0)
            {
                printTuple($irn1,"INEQ",$retVar2,$retVar0);
            }
            elsif($realchk0 == 1)
            {
                printTuple($irn1,"RNEQ",$retVar2,$retVar0);
            }
        
                for(1..3)
                {
                    pop @semStack;
                }
                push (@semStack,$irn1);
        }    
    }
    
    if($redNum==93)
    {
        print ("Prod $redNum \n");
    }
    
    
    if($redNum==94)
    {
        print ("Prod $redNum \n");
    }
    
    if($redNum==95)
    {
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; my $symTabIndex = $symTabLen-1;
	$localSTLen= scalar @localST; my $localSTIndex = $localSTLen-1;
        
        my ($retVar0,$realchk0) = checkSubscript($semStack[$semStackIndex]);
        my ($retVar2,$realchk2) = checkSubscript($semStack[$semStackIndex-2]);
        
        my $irn0;
        if($realchk0 == 1 || $realchk2 ==1)
        {
            $irn0 = "R\$".$irn; $irn++;
            printTuple($irn0,"RADD",$retVar2,$retVar0);
        }
        else
        {
            $irn0 = "I\$".$irn; $irn++;
            printTuple($irn0,"IADD",$retVar2,$retVar0);
        }
                for(1..3)
                {
                    pop @semStack;
                }
                push (@semStack,$irn0);
    }
    
    if($redNum==96)
    {
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; my $symTabIndex = $symTabLen-1;
	$localSTLen= scalar @localST; my $localSTIndex = $localSTLen-1;
        
        my ($retVar0,$realchk0) = checkSubscript($semStack[$semStackIndex]);
        my ($retVar2,$realchk2) = checkSubscript($semStack[$semStackIndex-2]);
        
        my $irn0;
        if($realchk0 == 1 || $realchk2 ==1)
        {
            $irn0 = "R\$".$irn; $irn++;
            printTuple($irn0,"RSUB",$retVar2,$retVar0);
        }
        else
        {
            $irn0 = "I\$".$irn; $irn++;
            printTuple($irn0,"ISUB",$retVar2,$retVar0);
        }
                for(1..3)
                {
                    pop @semStack;
                }
                push (@semStack,$irn0);
    }
 

    if($redNum==97)
    {
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; my $symTabIndex = $symTabLen-1;
	$localSTLen= scalar @localST; my $localSTIndex = $localSTLen-1;
        
        my ($retVar0,$realchk0) = checkSubscript($semStack[$semStackIndex]);
        
        
        my $irn0;
        if($realchk0 == 1)
        {
            $irn0 = "R\$".$irn; $irn++;
            printTuple($irn0,"RSUBT","0",$retVar0);
        }
        elsif($realchk0 == 0)
        {
            $irn0 = "I\$".$irn; $irn++;
            printTuple($irn0,"ISUBT","0",$retVar0);
        }
                for(1..2)
                {
                    pop @semStack;
                }
                push (@semStack,$irn0);
    }

  
   if($redNum==98)
   {
   	print ("Prod $redNum \n NULL");
   }

   if($redNum==99)
   {
   	print ("Prod $redNum \n NULL");
   }
 
 
    if($redNum==100)
    {
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; my $symTabIndex = $symTabLen-1;
	$localSTLen= scalar @localST; my $localSTIndex = $localSTLen-1;
        
        my ($retVar0,$realchk0) = checkSubscript($semStack[$semStackIndex]);
        my ($retVar2,$realchk2) = checkSubscript($semStack[$semStackIndex-2]);
        
        my $irn0;
        if($realchk0 == 1 || $realchk2 ==1)
        {
            $irn0 = "R\$".$irn; $irn++;
            printTuple($irn0,"RMULT",$retVar2,$retVar0);
        }
        else
        {
            $irn0 = "I\$".$irn; $irn++;
            printTuple($irn0,"IMULT",$retVar2,$retVar0);
        }
                for(1..3)
                {
                    pop @semStack;
                }
                push (@semStack,$irn0);
    }
   
   
    if($redNum==101)
    {
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; my $symTabIndex = $symTabLen-1;
	$localSTLen= scalar @localST; my $localSTIndex = $localSTLen-1;
        
        my ($retVar0,$realchk0) = checkSubscript($semStack[$semStackIndex]);
        my ($retVar2,$realchk2) = checkSubscript($semStack[$semStackIndex-2]);
        
        my $irn0;
        if($realchk0 == 1 || $realchk2 ==1)
        {
            $irn0 = "R\$".$irn; $irn++;
            printTuple($irn0,"RDIV",$retVar2,$retVar0);
        }
        else
        {
            $irn0 = "I\$".$irn; $irn++;
            printTuple($irn0,"IDIV",$retVar2,$retVar0);
        }
                for(1..3)
                {
                    pop @semStack;
                }
                push (@semStack,$irn0);
    }
    

    if($redNum==102)
    {
      	print ("Prod $redNum \n NULL");
        
    }
    
    if($redNum==103)
    {
        print ("Prod $redNum\n");
	$semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; 
	$localSTLen= scalar @localST;
        $semStack[$semStackIndex-2]=$semStack[$semStackIndex-1];
        for(1..2)
        {
            pop @semStack; getSemStackTop();
        }
    }
    
    if($redNum==104)
    {
        print ("Prod $redNum\n");
	$semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; 
	$localSTLen= scalar @localST;
	print ("Prod $redNum \n NULL");
        print ("print special tuple");
        $semStack[$semStackIndex] = "'".$semStack[$semStackIndex];
        #my $irn1 = "I\$".$irn; $irn++;
        #printTuple($irn1,"REMEMBERLOAD",$semStack[$semStackIndex],"-");
        #pop @semStack;
        #push (@semStack, $irn1);
    }
    
    if($redNum==105)
    {
        print ("Prod $redNum\n");
	$semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; 
	$localSTLen= scalar @localST;
	print ("Prod $redNum \n NULL");
        print ("print special tuple");
        $semStack[$semStackIndex] = "~".$semStack[$semStackIndex];
        #my $irn1 = "R\$".$irn; $irn++;
        #printTuple($irn1,"REMEMBERLOAD",$semStack[$semStackIndex],"-");
        #pop @semStack;
        #push (@semStack, $irn1);
    }
    
    if($redNum==106)
    {
	
	$semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; my $symTabIndex = $symTabLen-1;
	$localSTLen= scalar @localST; my $localSTIndex = $localSTLen-1;
        
        $semStack[$semStackIndex] = replaceVar($semStack[$semStackIndex]);
        print ("Prod $redNum \n NULL");
    }
    
    
    if($redNum==107)
    {
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; my $symTabIndex = $symTabLen-1;
	$localSTLen= scalar @localST; my $localSTIndex = $localSTLen-1;
        
        $semStack[$semStackIndex-3] = replaceVar($semStack[$semStackIndex-3]);
        if($notDecl==1)
        {
            push (@outputLines, "\t\t\t\t\t\tERROR: Variable $semStack[$semStackIndex-3] not declared.\n");
            print ("\t\t\t\t\t\tERROR: Variable $semStack[$semStackIndex-3] not declared.\n");
        }
        else
        {
        my $realchk1 = checkSubscript($semStack[$semStackIndex-1]);
        
        if($realchk1 == 1)
        {
            push (@outputLines, "\t\t\t\t\t\tERROR: Subscripts cannot be real.\n");
            print ("\t\t\t\t\t\tERROR: Subscripts cannot be real.\n");
        }
        else
        {
            my ($tup30,$tup31,$tup32,$tup33,$tup34) = returnLoc($semStack[$semStackIndex-3]);
            my ($tup10,$tup11,$tup12,$tup13,$tup14) = returnLoc($semStack[$semStackIndex-1]);
            my $irn0;
                if($tup31 eq "real")
                {   $irn0 = "R\$".$irn; $irn++;
                    printTuple($irn0,"SUBLOAD",$tup30,$tup10);
                }
                elsif($tup31 eq "integer")
                {
                    $irn0 = "I\$".$irn; $irn++;
                    printTuple($irn0,"SUBLOAD",$tup30,$tup10);
                }
        
            for(1..4)
            {
                pop @semStack;
            }
            push (@semStack, $irn0);
        }
        }
    }
    
    
    if($redNum==108)
    {
        $semLen= scalar @semStack; $semStackIndex = $semLen-1;
	$symTabLen = scalar @symTab; my $symTabIndex = $symTabLen-1;
	$localSTLen= scalar @localST; my $localSTIndex = $localSTLen-1;
        
        $semStack[$semStackIndex-5] = replaceVar($semStack[$semStackIndex-5]);
        if($notDecl==1)
        {
            push (@outputLines, "\t\t\t\t\t\tERROR: Variable $semStack[$semStackIndex-5] not declared.\n");
            print ("\t\t\t\t\t\tERROR: Variable $semStack[$semStackIndex-5] not declared.\n");
        }
        else
        {
        my $realchk1 = checkSubscript($semStack[$semStackIndex-1]);
        my $realchk3 = checkSubscript($semStack[$semStackIndex-3]);
        
        if($realchk1 == 1 || $realchk3 == 1)
        {
            push (@outputLines, "\t\t\t\t\t\tERROR: Subscripts cannot be real.\n");
        }
        else
        {
            
            my ($tup50,$tup51,$tup52,$tup53,$tup54) = returnLoc($semStack[$semStackIndex-5]);
            my ($tup30,$tup31,$tup32,$tup33,$tup34) = returnLoc($semStack[$semStackIndex-3]);
            my ($tup10,$tup11,$tup12,$tup13,$tup14) = returnLoc($semStack[$semStackIndex-1]);
            
            my $irn1 = "I\$".$irn; $irn++;
            my $irn2 = "I\$".$irn; $irn++;
            my $irn3;
            
            printTuple($irn1,"IMULT",$tup30,$tup54);
            printTuple($irn2,"IADD",$irn1,$tup10);
            
            if($tup51 eq "real")
            {
                $irn3 = "R\$".$irn; $irn++;
                printTuple($irn3,"SUBLOAD",$tup50,$irn2);
            }
            elsif($tup51 eq "integer")
            {
                $irn3 = "I\$".$irn; $irn++;
                printTuple($irn3,"SUBLOAD",$tup50,$irn2);
            }
        
        for(1..6)
        {
            pop @semStack;
        }
        push (@semStack, $irn3);
        }
        }
    }
}#semantics end


sub printTuple
    {
        if($flags[13] == 1)
        {
            
            push (@outputLines, "\t\t\t\t\t\tReduction ".$redNum."--->($_[0],$_[1],$_[2],$_[3])\n");
        }
        if($flags[20] == 1)
        {
            push (@outputLines, "\t\t\t\t\t\tReduction ".$redNum."--->(20,FLAG,-,-)\n");
        }
        push (@ftupleOutput,"($_[0],$_[1],$_[2],$_[3])");
        $ftuple[$ftupleIndex][0]=$_[0];
        $ftuple[$ftupleIndex][1]=$_[1];
        $ftuple[$ftupleIndex][2]=$_[2];
        $ftuple[$ftupleIndex][3]=$_[3];
        $ftupleIndex++;
        
    }
    
    sub returnLoc
    {
        $semVar = $_[0];
        $toChk=substr($semVar,0,1);
        
        if($toChk eq "I")
        {
            return $semVar;
        }
        elsif($toChk eq "R")
        {
            return $semVar;
        }
        elsif($toChk eq "`")
        {
                
                my $n =1;
                $semVar =~ s/^.{$n}//s;
                return $semVar;
        }
        elsif($toChk eq "'")
        {
                
                my $n =1;
                $semVar =~ s/^.{$n}//s;

                #$semVar = substr($semVar,1);
                return $semVar;
        }
        elsif($toChk eq "-")
        {
            $len = length($semVar);
            $semVar = substr($semVar,$len-1);
            
            return ($symTab[$semVar][0],$symTab[$semVar][1],$symTab[$semVar][2],$symTab[$semVar][3],$symTab[$semVar][4],);
            
        }
        else
        {
            if($procFlag == 0)
            {
                return ($symTab[$semVar][0],$symTab[$semVar][1],$symTab[$semVar][2],$symTab[$semVar][3],$symTab[$semVar][4],);
                
            }
            elsif($procFlag == 1)
            {
                return ($localST[$semVar][0],$localST[$semVar][1],$localST[$semVar][2],$localST[$semVar][3],$localST[$semVar][4],);
            }
        }
    }
    
    sub checkSubscript
    {
        my $retVar;
        $semVar = $_[0];
        
        my $realScript = 0;
        $yesBoole = 0;
            
            $toChk=substr($semVar,0,1);
            
            if($toChk eq "B")
            {
                $yesBoole = 1;
                $retVar = $semVar;
            }
            elsif($toChk eq "R")
            {
                $realScript = 1;
                $retVar = $semVar;
            }
            elsif($toChk eq "I")
            {
                $realScript = 0;
                $retVar = $semVar;
            }
            elsif($toChk eq "`")
            {
                $realScript = 1;
                my $n =1;
                $semVar =~ s/^.{$n}//s;
                $retVar = "$semVar";
            }
            elsif($toChk eq "'")
            {
                $realScript = 0;
                my $n =1;
                $semVar =~ s/^.{$n}//s;
                #$semVar = substr($semVar,$len-1);
                $retVar = "$semVar";
            }
            elsif($toChk eq "-")
            {
                my $n =1;
                $semVar =~ s/^.{$n}//s;
                if($symTab[$semVar][1] eq "real")
                {
                    $realScript = 1;
                    $retVar = $symTab[$semVar][0];
                }
                elsif($symTab[$semVar][1] eq "integer")
                {
                    $realScript = 0;
                    $retVar = $symTab[$semVar][0];
                }
                $semVar = "-".$semVar;
            }
            else
            {
                if($procFlag==0)
                {
                    if($symTab[$semVar][1] eq "real")
                    {
                        $realScript = 1;
                        $retVar = $symTab[$semVar][0];
                    }
                    elsif($symTab[$semVar][1] eq "integer")
                    {
                        $realScript = 0;
                        $retVar = $symTab[$semVar][0];
                    }
                }
                elsif($procFlag==1)
                {
                    if($localST[$semVar][1] eq "real")
                    {
                        $realScript = 1;
                        $retVar = $localST[$semVar][0];
                    }
                    elsif($localST[$semVar][1] eq "integer")
                    {
                        $realScript = 0;
                        $retVar = $localST[$semVar][0];
                    }
                }
            }
        return ($retVar,$realScript);
    }
    
    sub replaceVar
    {
        $semVar = $_[0];
        $notDecl=0;
            $semLen= scalar @semStack; $semStackIndex = $semLen-1;
            $symTabLen = scalar @symTab; my $symTabIndex = $symTabLen-1;
            $localSTLen= scalar @localST; my $localSTIndex = $localSTLen-1;
        if($procFlag!=0)                #to put the pointer to symtab or localst for the variable on semStack
        {
            while($localSTIndex!=-1&&$semVar ne $localST[$localSTIndex][0])
            {
                $localSTIndex--;
                print $localSTIndex;
            }
            if($localSTIndex==-1)
            {
                while($symTabIndex!=-1 && $semVar ne $symTab[$symTabIndex][0])
                {
                    $symTabIndex--;
                }
                if($symTabIndex == -1)
                {
                    $notDecl = 1;
                }
                else
                {
                    $semVar = "-".$symTabIndex;
                }
            }
            else
            {
                $semVar = $localSTIndex;
            }
        }
        else
        {
            while($symTabIndex!=-1 &&  $semVar ne $symTab[$symTabIndex][0])
            {
                $symTabIndex--;
            }
            if($symTabIndex == -1)
                {
                    $notDecl = 1;
                }
                else
                {
                    $semVar = $symTabIndex;
                }
        }
        
        return $semVar;
    }
    
    
    
#####################################################################################
#################################PRAGMATICS##########################################
#####################################################################################
#
#
#######################################################

sub availableRegister
{
	my $i = -1;
	for($i=0; $i<$PHYREGS; $i++)
	{
	  if($phyReg[$i] eq "-")
          {
		 return $i;
          }
	}
        return $i;
}

sub addMemInfo
{
    my $tup0 = $_[0];
    my $tup3 = $_[1];
    my $tup4 = $_[2];
    my $size = 0;
    
    
    
    if($tup3 ne "-" && $tup4 ne "-")
    {
        $size = 4*($tup3*$tup4);
    }
    elsif($tup3 ne "-")
    {
        $size = 4 * ($tup3);
    }
    elsif($tup3 eq "-")
    {
        $size = 4;
    }

    $fpoffset+=$size;
    $memStack{$tup0} = $fpoffset;
    $sizeMem{$tup0} = $size;
    $fpoffset1 = $fpoffset;
    
}



sub findMemInfo
{
    my $name = $_[0];
    
    my $memLen = scalar @memStack;
    
    while($memLen!=0 && $memStack[$memLen-1] ne $name)
    {
        $memLen--;
    }
    if($memLen != 0)
    {
        return -$memStack[$memLen-1][1];
    }
    else
    {
        return 0;
    }
}
        



sub searchArray             
{
    my @array = $_[1];
    my $what = $_[0];
    my $length = scalar @array;
    for($i=0; $i<$length; $i++)
    {
        if($array[$i][0] eq $what)
        {
            return $i;      
        }
    }
    return -1;      
}



sub loadOperand
{
    my $operand = $_[0];
    my $i = $_[1];
    if($operand =~ /\G^[a-z]+([a-z]|[0-9]|_)*/gc)
    {
        my $locn = findMemInfo($operand);
        if($locn <=0)
        {
            $locn = $locn + $beginFP;
        }
        if($locn <0)
        {
            push (@pragftuple,"\tld\t[\%fp$locn], \%l$i");
        }
        else
        {
            push (@pragftuple,"\tld\t[\%fp+$locn], \%l$i");
        }
    }
}

sub getRegister
{
    for ( my $i = 0; $i < $PHYREGS; $i++ )
    {
        if ( $phyReg[$i] eq "-" )
        {
            return ($i);
        }
    }

    return (-1);
}

sub regLoad
{
    my $op1    = shift;
    my $op2    = shift;
    my $op1Reg = -1;

    $op1Reg = searchPhyReg($op1);

    if ( $op1Reg == -1 )
    {
        if ( $op1 =~ /[IRB]\$\d+$/ )
        {
            for ( my $i = 0; $i < $numVirtReg; $i++ )
            {
                if ( $virReg[$i] =~ /$op1/ )
                {
                    print "Need to account for virtual registers\n";
                }
            }
        } 

        $op1Reg = getRegister ();

        if ( $op1Reg == -1 )
        {
            for ( my $i = 0; $i < $PHYREGS; $i++ )
            {
                if ( $phyReg[$i] =~ /^\d+$/ )
                {
                    if ( !( $op2 =~ /-/ ) )
                    {
                        if ( $phyReg[$i] =~ /$op2/ )
                        {
                            next;
                        }
                    } 

                    $op1Reg = $i;
                    last;
                } 
            } 
        } 

        if ( $op1Reg == -1 )
        {
            for ( my $i = 0; $i < $PHYREGS; $i++ )
            {
                if ( $phyReg[$i] =~ /\w+/ )
                {
                    if ( !( $op2 =~ /-/ ) )
                    {
                        if ( $phyReg[$i] =~ /$op2/ )
                        {
                            next;
                        }
                    } 

                    $op1Reg = $i;
                    last;
                } 
            } 
        } 

        if ( $op1Reg == -1 )
        {
            for ( my $i = 0; $i < $PHYREGS; $i++ )
            {
                if ( !( $op2 =~ /-/ ) )
                {
                    if ( !( $phyReg[$i] =~ /$op2/ ) )
                    {
                        $op1Reg = $i;
                        last;
                    } 
                } 
            } 
        } 
    } 
    my $str = "-";

    if ( $op1 =~ /^\d+$/ )
    {
        $phyReg[$op1Reg] = "-";
    }
    elsif ( $op1 =~ /[IRB]\$\d+$/ )
    {
        $phyReg[$op1Reg] = "$op1";
    }
    else
    {
        $str = "\tld\t[\%fp-$memStack{$op1}], \%l${op1Reg}\n";
        push (@pragftuple, "$str" );
        $phyReg[$op1Reg] = "$op1";
    } 

    return ($op1Reg);
} 




sub consVarIRN
{
    my $operand1 = $_[0];
    my $operand2 = $_[1];
    my $i;
    
    for($i=0;$i<$PHYREGS;$i++)
    {
        if($phyReg[$i] eq "-")
        {
            $phyReg[$i] = $operand1;
            return $i;
        }
    }
    
    for($i=0;$i<$PHYREGS;$i++)
    {
        if (($phyReg[$i] =~ /\G^[+-]?(\d+|\d+\.\d+|\.\d+)/gc) && $phyReg[$i] != $operand2)
        {
            $phyReg[$i] = $operand1;
            return $i;
        }
    }
    
    for($i=0;$i<$PHYREGS;$i++)
    {
        if (($phyReg[$i] =~ /\G^[a-z]+([a-z]|[0-9]|_)*/gc) && $phyReg[$i] ne $operand2)
        {
            $phyReg[$i] = $operand1;
            return $i;
        }
    }
    
    for($i=0;$i<$PHYREGS;$i++)
    {
        if (($phyReg[$i] =~ /\G^[IRB]/gc) && $phyReg[$i] ne $operand2)
        {
            my $j=0;
            while($virReg[$j] ne "-")
            {
                $j++;
            }
            $virReg[$j] = $phyReg[$i];
            $phyReg[$i] = $operand1;
            return $i;
        }
    }
}
    

sub regStore

{
    my $result = shift;
    my $op1    = shift;
    my $op2    = shift;
    my $ret    = -1;

    if ( $op1 =~ /[IRB]\$\d+$/ )
    {
        for ( my $i = 0; $i < $PHYREGS; $i++ )
        {
            if ( $phyReg[$i] =~ /$op1/ )
            {
                $phyReg[$i] = "-";
            }
        } 
    } 

    if ( $op2 =~ /[IRB]\$\d+$/ )
    {
        for ( my $i = 0; $i < $PHYREGS; $i++ )
        {
            if ( $phyReg[$i] =~ /$op2/ )
            {
                $phyReg[$i] = "-";
            }
        } 
    } 
    $ret = getRegister ();

    if ( $ret == -1 )
    {
        for ( my $i = 0; $i < $PHYREGS; $i++ )
        {
            if ( $phyReg[$i] =~ /^\d+$/ )
            {
                $ret = $i;
                last;
            } 
        } 
    } 

    if ( $ret == -1 )
    {
        for ( my $i = 0; $i < $PHYREGS; $i++ )
        {
            if ( $phyReg[$i] =~ /\w+/ )
            {
                $ret = $i;
                last;
            } 
        }
    } 

    if ( $ret == -1 )
    {
        die "ERROR: I don't have a register to store results\n";
    }

    $phyReg[$ret] = "$result";

    return ($ret);
} 
    

sub freePhyIntmdtRes
{
    my $op1 = $_[0];
    my $i=0;
    if($phyReg[$i] =~ /\G\$/gc) 
    {
        for($i=0;$i<$PHYREGS;$i++)
        {
            if($phyReg[$i] eq $op1)
            {
                $phyReg[$i] = "-";
            }
        }
    }
}


sub freeVarReg
{
   my $m;
   for($m=0; $m<$PHYREGS ; $m++)
   {
        if ($phyReg[$m] =~ /\G^[a-z]+([a-z]|[0-9]|_)*/gc) 
	{
            $phyReg[$m]="-";
        }
   }   
}


sub labelIndex
{
	my $ftup0 = $_[0];
        if($ftup0 eq "MAIN")
        {
            return 0;
        }
        else
        {
            my $labelno = substr($ftup0,2,1);
            return $labelno;
        }
}




sub funcStart      
{
        my $funcName = $_[0];
    
    push (@pragftuple,"\t.align 4 ");
    push (@pragftuple,"\t.global $funcName");
    push (@pragftuple,"\t.type $funcName, #function");
    push (@pragftuple,"$funcName:");
	printf("\t.align 4 ");
        printf("\t.global $funcName");
	printf("\t.type $funcName, #function");
	printf("func_start $funcName:");
}


sub funcEnd        
{
    my $funcName = $_[0];
    push (@pragftuple,"\tnop");
    push (@pragftuple,"\tret ");
    push (@pragftuple,"\trestore ");
    push (@pragftuple,"\t.size\t$funcName, .-$funcName\n");
   	
    if($funcName eq "Static")
    {
       
        push (@pragftuple,"\t.local\t E\n");
        push (@pragftuple,"\t.common\t E,4,4\n");
        push (@pragftuple,"\t.local\t F\n");
        push (@pragftuple,"\t.common\t F,4,4\n");
        push (@pragftuple,"\t.local\t G\n");
        push (@pragftuple,"\t.common\t G,4,4\n");
    }
    
    print("\tnop");
    print("\tret ");
    print("\trestore ");
    print("\t.size\t$funcName, .-$funcName\n");
}


sub freeIntmdVar2
{
    
    my $i;
    my $ftup1 = $_[0];
    my $ftup2 = $_[1];
    my $toChk1 = substr($ftup1,0,1);
	if(( $toChk1 eq 'I' || $toChk1 eq 'R' || $toChk1 eq 'B'))
	{ 
		for($i=0; $i<$PHYREGS; $i++)
		{
			if( $phyReg[$i] eq $ftup1)
			{
				$phyReg[$i]="-";
			}
		}
    }
    
    my $toChk2 = substr($ftup2,0,1);    
    if(( $toChk2 eq 'I' || $toChk2 eq 'R' || $toChk2 eq 'B'))
    { 
        for($i=0; $i<$PHYREGS && $phyReg[$i] !=$ftup2; $i++)
	{
	    if($phyReg[$i] eq $ftup2)
	    {
                print("ftup_2 matched.phy_regs[i] is $phyReg[$i]\n");
                
		$phyReg[$i] = "-";
	    }
        }
    }
}

sub freeRegister
{
    my $name = $_[0];
   my $i;
   for($i=0; $i< $PHYREGS; $i++)
   {
	if($phyReg[$i] eq $name)
	{
            if( $i <$PHYREGS )
            {
                $phyReg[$i] = "-";
            }
        }
   }
}

sub freePhyReg
{
   my $m;
   for($m=0; $m<$PHYREGS ; $m++)        
   {
        $phyReg[$m]="-";
   }
}


sub freeVirReg
{
    my $m;
   for($m=0; $m<$PHYREGS ; $m++)            
   {
        $phyReg[$m]="-";
   }
}



sub searchPhyReg
{
    my $tup0 = $_[0];
    my $i; my $ret = -1;
    
    for($i=0; $i<$PHYREGS; $i++)
    {
        if($phyReg[$i] eq "$tup0")
        {
            $ret = $i;
        }
    }
    return $ret;
}
#######################################################################################################################
PRAGMATICS:


my $ftupLen = scalar @ftuple;
my $count1 = 0;
my $operation;
my $procEntered=0;

        open (PRAGFTOUTPUT, ">$pragFTuple") or die "Cant find the specified file: $!\n";
	
	for my $out1 (@pragftuple)
	{
		print PRAGFTOUTPUT "$out1\n";
	}
	
	close (FTOUTPUT);
        

	push (@pragftuple,"! PROGRAM TO ADD TWO SCALAR VALUES \n");
	push (@pragftuple,"\t.file \"fourTuple\" ");
        push (@pragftuple,"\t.global .umul");
        push (@pragftuple,"\t.section \".rodata\"");
        push (@pragftuple,"\tnum:\t.asciz \"\%d\"\n" );
        push (@pragftuple,"\t.align 8");		
        push (@pragftuple,".LLC0:");
        push (@pragftuple,"\t.asciz \"\%d \"");
        push (@pragftuple,"\t.align 8");
        push (@pragftuple,".LLC1:");
        push (@pragftuple,"\t.asciz \"\%d\"");
        push (@pragftuple,"\t.section \".text\"\n");
        
   
while($count1<$ftupLen)
{
             
                if($ftuple[$count1][1] eq "PROGRAMBEGIN")
                {
			push (@pragftuple,"\t\t!($ftuple[$count1][0], $ftuple[$count1][1],$ftuple[$count1][2],$ftuple[$count1][3])");
                }
                
		elsif($ftuple[$count1][1] eq "PROGRAMEND")
                {
                    push (@pragftuple,"\t\t!($ftuple[$count1][0], $ftuple[$count1][1],$ftuple[$count1][2],$ftuple[$count1][3])");    
                    push (@pragftuple, "\n\tret\n" );
                    push (@pragftuple, "\trestore\n" );
                    
                    if($pragproc == 1)
                    {
                        $count1 = $procCount - 1;
                        $finStart = 0;
                        
                    }
                    
                    
                }
                
                
                elsif($ftuple[$count1][1] eq "MEMORY")
                {
                    push (@pragftuple,"\t\t!($ftuple[$count1][0], $ftuple[$count1][1],$ftuple[$count1][2],$ftuple[$count1][3])");
                    addMemInfo($ftuple[$count1][0],$ftuple[$count1][2],$ftuple[$count1][3]);
                }
                
                elsif($ftuple[$count1][1] eq "DECLARATIONEND")
                {
                    push (@pragftuple,"\t\t!($ftuple[$count1][0], $ftuple[$count1][1],$ftuple[$count1][2],$ftuple[$count1][3])");
                    $operation = 6;   
                }
                
         
            elsif($ftuple[$count1][1] eq "LABEL")
            {
                push (@pragftuple,"\t\t!($ftuple[$count1][0], $ftuple[$count1][1],$ftuple[$count1][2],$ftuple[$count1][3])");
                if ( $ftuple[$count1][0] eq "MAIN" )
                {
                    
                    push (@pragftuple, "\t.global main\n" );
                    push (@pragftuple, "\t.align 4\n" );
                    my $tmp;
                    $fpoffset1*=-1;
                    $fpoffset1-=112;
                    if($fpoffset1 % 8)
                    {
                       $fpoffset1-=4;
                    }
                    
                    push (@pragftuple, "main:\n\tsave\t\%sp, ".$fpoffset1.", \%sp\n\n" );
                }
                else
                {
                    my $str = $ftuple[$count1][0];
                    $str =~ s/\$/L/;
                    push (@pragftuple, "\n.${str}:\n" );
                }

                    freePhyReg();
                    freeVirReg();
            
            }
            
        elsif ( $ftuple[$count1][1] eq "CJUMPF" )
        {
            push (@pragftuple,"\t\t!($ftuple[$count1][0], $ftuple[$count1][1],$ftuple[$count1][2],$ftuple[$count1][3])");
            my $op1 = regLoad ( $ftuple[$count1][2], $ftuple[$count1][3] );
            my $str = "";

            my $tempReg = regStore ( $ftuple[$count1][0], $ftuple[$count1][2], $ftuple[$count1][3] );

            
            if ( $bool == 1 )
            {
                my $label = $ftuple[$count1][0];
                $label =~ s/\$/L/;
                $str = "\tble\t.${label}\n";
            } 
            elsif ( $bool == 2 )
            {
                my $label = $ftuple[$count1][0];
                $label =~ s/\$/L/;
                $str = "\tbge\t.${label}\n";

            } 

            elsif ( $bool == 3 )
            {
                my $label = $ftuple[$count1][0];
                $label =~ s/\$/L/;
                $str = "\tbne\t.${label}\n";

            } 
            elsif ( $bool == 4 )
            {
                my $label = $ftuple[$count1][0];
                $label =~ s/\$/L/;
                $str = "\tbe\t.${label}\n";
            } 
            push (@pragftuple, $str );
            $str = "\tnop\n";
            push (@pragftuple, $str );

        } 
        
        
        elsif ( $ftuple[$count1][1] eq "IL" )
        {
            push (@pragftuple,"\t\t!($ftuple[$count1][0], $ftuple[$count1][1],$ftuple[$count1][2],$ftuple[$count1][3])");
            my $str = "";
            $bool = 2;
            my $op1 = regLoad ( $ftuple[$count1][2], $ftuple[$count1][3] );
            my $op2 = regLoad ( $ftuple[$count1][3], $ftuple[$count1][2] );

            my $tempReg = regStore ( $ftuple[$count1][0], $ftuple[$count1][2], $ftuple[$count1][3] );

            

            my $field1 = "\%l${op1}";
            my $field2 = "\%l${op2}";

            if ( $ftuple[$count1][2] =~ /^\d+$/ )
            {
                $field1 = "$ftuple[$count1][2]";
            }

            if ( $ftuple[$count1][3] =~ /^\d+$/ )
            {
                $field2 = "$ftuple[$count1][3]";
            }
            $str = "\tcmp\t${field1},${field2}\n";
            push (@pragftuple, "$str" );
        }
        
        elsif ( $ftuple[$count1][1] eq "SUBSTORE" )
        {
            push (@pragftuple,"\t\t!($ftuple[$count1][0], $ftuple[$count1][1],$ftuple[$count1][2],$ftuple[$count1][3])");
            my $baseVal    = $memStack{ $ftuple[$count1][0] };
            my $newBaseVal = $baseVal * -1;            
            my $tmpReg  = 0;
            my $offset  = 0;
            my $str     = "";

            if ( $ftuple[$count1][3] ne "-" )
            {
                if ( $ftuple[$count1][3] =~ /^\d+$/ )
                {
                    push (@pragftuple, "\tmov\t$ftuple[$count1][3], \%g1\n" );
                } 
                else
                {
                    $tmpReg = regLoad ( $ftuple[$count1][3], "-" );
                    push (@pragftuple, "\tmov\t\%l$tmpReg, \%g1\n" );
                }
            

                push (@pragftuple, "\tsll\t\%g1, 2, \%g2\n" );

                push (@pragftuple, "\tadd\t\%fp, $newBaseVal, \%g1\n" );
                push (@pragftuple, "\tadd\t\%g2, \%g1, \%g2\n" );
                if ( $ftuple[$count1][2] =~ /^\d+$/ )
                {
                    push (@pragftuple, "\tmov\t$ftuple[$count1][2], \%g1\n" );
                }
                else
                {
                    $tmpReg = regLoad ( $ftuple[$count1][2], "-" );
                    push (@pragftuple, "\tmov\t\%l$tmpReg, \%g1\n" );
                } 
                push (@pragftuple, "\tst\t\%g1, [\%g2]\n" );
            } 
            else
            {
                if ( $ftuple[$count1][2] =~ /^\d+$/ )
                {
                    if ( $ftuple[$count1][2] == 0 )
                    {
                        push (@pragftuple, "\tst\t\%g0, [\%fp-$baseVal]\n" );
                    }
                    else
                    {
                        push (@pragftuple, "\tmov\t$ftuple[$count1][2], \%g1\n" );
                        push (@pragftuple, "\tst\t\%g1, [\%fp-$baseVal]\n" );
                    }
                } 
                else
                {
                    $tmpReg = regLoad ( $ftuple[$count1][2], "-" );
                    push (@pragftuple, "\tmov\t\%l$tmpReg, \%g1\n" );
                    push (@pragftuple, "\tadd\t\%fp, $newBaseVal, \%g2\n" );
                    push (@pragftuple, "\tst\t\%g1, [\%g2]\n" );
                }
            } 
            
        }
        
                elsif ( $ftuple[$count1][1] eq "SUBLOAD" )
        {
            push (@pragftuple,"\t\t!($ftuple[$count1][0], $ftuple[$count1][1],$ftuple[$count1][2],$ftuple[$count1][3])");
            my $baseVal = $memStack{ $ftuple[$count1][2] };
            $baseVal = $baseVal * -1;    
            my $tmpReg = 0;
            my $offset = 0;
            my $str    = "";

            if ( $ftuple[$count1][3] =~ /^\d+$/ )
            {
                push (@pragftuple, "\tmov\t$ftuple[$count1][3], \%g1\n" );
            } 
            else
            {
                $tmpReg = regLoad ( $ftuple[$count1][3], $ftuple[$count1][2] );
                push (@pragftuple, "\tmov\t\%l$tmpReg, \%g1\n" );
            } 

            push (@pragftuple, "\tsll\t\%g1, 2, \%g2\n" );
            push (@pragftuple, "\tadd\t\%fp, $baseVal, \%g3\n" );
            push (@pragftuple, "\tadd\t\%g2, \%g3, \%g1\n" );
            push (@pragftuple, "\tld\t[\%g1], \%o1\n" );
            $tmpReg = regLoad ( $ftuple[$count1][3], $ftuple[$count1][2] );
            push (@pragftuple, "\tld\t[\%g1], \%l$tmpReg\n" );
            $phyReg[$tmpReg] = $ftuple[$count1][0];
        }
        
        
        
        elsif ( $ftuple[$count1][1] eq "JUMP" )
        {
            push (@pragftuple,"\t\t!($ftuple[$count1][0], $ftuple[$count1][1],$ftuple[$count1][2],$ftuple[$count1][3])");
            my $str   = "";
            my $label = $ftuple[$count1][0];
            $label =~ s/\$/L/;
            $label = "." . $label;
            $str   = "\tba\t${label}";
            push (@pragftuple, $str );
            push (@pragftuple, "\tnop\n" );
        }
        
        
                elsif($ftuple[$count1][1] eq "BEGINEXECUTION")
                {
                    push (@pragftuple,"\t\t!($ftuple[$count1][0], $ftuple[$count1][1],$ftuple[$count1][2],$ftuple[$count1][3])");
                    $operation = 17;
                }
                
   
        elsif( $ftuple[$count1][1] eq 'IADD')
	{
            push (@pragftuple,"\t\t! ($ftuple[$count1][0],$ftuple[$count1][1],$ftuple[$count1][2],$ftuple[$count1][3])");
	    my $ftup1 = $ftuple[$count1][0];
	    my $ftup2 = $ftuple[$count1][1];
	    my $ftup3 = $ftuple[$count1][2];
	    my $ftup4 = $ftuple[$count1][3];
	    
	    if($ftup4 =~ /(I|R|i|r)\$.*/)
            {		
		my $loc = regLoad($ftup4);
		push (@pragftuple,"\tmov   \%l$loc, \%o1\n");		
	    }
	    elsif ($ftup4 =~ /[a-z]/)
            {
		my $loc = $memStack{$ftup4};
                push (@pragftuple,"\tld\t  [\%fp-$loc], \%o1\n");
		 
	    }
	    elsif ($ftup4 =~ /[0-9]/)
            {
		push (@pragftuple,"\tmov\t$ftup4, \%o1\n");	
	    }
	    
	    if($ftup3 =~ /(I|R|i|r)\$.*/)
            {		
		my $loc = regLoad($ftup3);
		push (@pragftuple,"\tmov   \%l$loc, \%o0\n");		
	    }
	    elsif ($ftup3 =~ /[a-z]/)
            {
		my $loc = $memStack{$ftup3};
                push (@pragftuple,"\tld\t  [\%fp-$loc], \%o0\n");
		 
	    }
	    elsif ($ftup3 =~ /[0-9]/)
            {
		push (@pragftuple,"\tmov\t$ftup3, \%o0\n");	
	    }
	    
	    my $loc = regStore($ftup1,$ftup2,$ftup3);
	    push (@pragftuple,"\tadd \%o0, \%o1, \%l$loc\n");	            
	}
             
        elsif( $ftuple[$count1][1] eq 'IMULT')
	{
            push (@pragftuple,"\t\t! ($ftuple[$count1][0],$ftuple[$count1][1],$ftuple[$count1][2],$ftuple[$count1][3])");
	    my $ftup1 = $ftuple[$count1][0];
	    my $ftup2 = $ftuple[$count1][1];
	    my $ftup3 = $ftuple[$count1][2];
	    my $ftup4 = $ftuple[$count1][3];
	    
	    if($ftup4 =~ /(I|R|i|r)\$.*/)
            {		
		my $loc = regLoad($ftup4);
		push (@pragftuple,"\tmov   \%l$loc, \%o1\n");		
	    }
	    elsif ($ftup4 =~ /[a-z]/)
            {
		my $loc = $memStack{$ftup4};
                push (@pragftuple,"\tld\t  [\%fp-$loc], \%o1\n");
		 
	    }
	    elsif ($ftup4 =~ /[0-9]/)
            {
		push (@pragftuple,"\tmov\t$ftup4, \%o1\n");	
	    }
	    
	    if($ftup3 =~ /(I|R|i|r)\$.*/)
            {		
		my $loc = regLoad($ftup3);
		push (@pragftuple,"\tmov   \%l$loc, \%o0\n");		
	    }
	    elsif ($ftup3 =~ /[a-z]/)
            {
		my $loc = $memStack{$ftup3};
                push (@pragftuple,"\tld\t  [\%fp-$loc], \%o0\n");
		 
	    }
	    elsif ($ftup3 =~ /[0-9]/)
            {
		push (@pragftuple,"\tmov\t$ftup3, \%o0\n");	
	    }
	    
	    my $loc = regStore($ftup1,$ftup2,$ftup3);
	                
                push (@pragftuple,"\tcall\t.umul, 0\n");
		push (@pragftuple,"\tnop\n");			
		$loc = regStore($ftup1, $ftup3, $ftup4);
		push (@pragftuple,"\tmov\t\%o0, %l$loc\n");
	}   
                
                elsif($ftuple[$count1][1] eq "BEGINACTUALPARAMETERS")
                {
		    push (@pragftuple,"\t\t! ($ftuple[$count1][0],$ftuple[$count1][1],$ftuple[$count1][2],$ftuple[$count1][3])");
		    my $num_params=0;
                    $count1++; 
		    my $fp_offset = 68;
		    while ($ftuple[$count1][1] eq "ENDACTUALPARAMETER")
		    {
                        push (@pragftuple,"\t\t! ($ftuple[$count1][0],$ftuple[$count1][1],$ftuple[$count1][2],$ftuple[$count1][3])");
			$num_params++;
			addMemInfo($ftuple[$count1][0], $fp_offset );
			$fp_offset = $fp_offset + 4;
                        $count1++; 
		    }			
		    push (@pragftuple,"\t\t! ($ftuple[$count1][0],$ftuple[$count1][1],$ftuple[$count1][2],$ftuple[$count1][3])");
                }
            
                elsif ( $ftuple[$count1][1] eq "PROCEDURECALL" )
                {
                    if($ftuple[$count1][0] eq "PRINT")
                    {
                        push (@pragftuple,"\t\t! ($ftuple[$count1][0],$ftuple[$count1][1],$ftuple[$count1][2],$ftuple[$count1][3])");
                        $procName = "$ftuple[$count1][0]";
                        push (@pragftuple, "\tset num, \%o${outRegNum}\n" );
                        $outRegNum++;
                    }
                    else
                    {
                        push (@pragftuple,"\t\t! ($ftuple[$count1][0],$ftuple[$count1][1],$ftuple[$count1][2],$ftuple[$count1][3])");
                        $procName = $ftuple[$count1][0];
                        $count1 = $count1+2;
                        my $loc = $memStack{$ftuple[$count1][2]};
                        push (@pragftuple,"\tld\t  [\%fp-$loc], \%o0\n");
                        push (@pragftuple,"call ${procName},0\n");
                        push (@pragftuple,"\tnop\n");
                    }
                } 
                
                elsif($ftuple[$count1][1] eq "FPARAMETER")
                {
                    push (@pragftuple,"\t\t! ($ftuple[$count1][0],$ftuple[$count1][1],$ftuple[$count1][2],$ftuple[$count1][3])");
                    push (@pragftuple, "\tsave\t\%sp, $sp , \%sp\n\n" );
                    push (@pragftuple, "\tst\t\%i0, [\%fp-4]\n" );
                    $memStack{'k'} = '4';
                    
                }
                
                
                
                   
                elsif ( $ftuple[$count1][1] eq "ACTUALPARAMETER" )
                {
                    push (@pragftuple,"\t\t! ($ftuple[$count1][0],$ftuple[$count1][1],$ftuple[$count1][2],$ftuple[$count1][3])");
                    my $op1 = regLoad ( $ftuple[$count1][2], $ftuple[$count1][3] );
                    my $str = "\tmov\t%l${op1}, \%o${outRegNum}";
                    push (@pragftuple,"$str");
                }
                      
                                        
                elsif ( $ftuple[$count1][1] eq "ENDACTUALPARAMETER" )
                {

                    if ( $procName =~ /PRINT/ )
                    {
                        
                        push (@pragftuple, "\tcall printf\n" );
                        push (@pragftuple, "\tnop\n" );
                        $procName = "";
                        $outRegNum  = 0;
                    }
                } 
        
                elsif($ftuple[$count1][1] eq "PROCEDURE")
                {
                    $pragproc = 1;
                    $procCount = $count1;
                    if($finStart == 1 )
                    {
                    
                        while($ftuple[$count1][1] ne "PROCEDUREEND")
                        {
                            $count1++;
                        }
                    
                    }
                    
                    
                    else
                    {
                        funcStart($ftuple[$count1][0]);
                        
                    }
                    
                }
                
                elsif($ftuple[$count1][1] eq "BEGINPARAMETERLIST")
                {
                    print "here";
                }
                elsif($ftuple[$count1][1] eq "ENDFPARAMETERLIST"){$operation = 9;}
                
                
                elsif($ftuple[$count1][1] eq "PROCEDUREEND") {
                 
                     funcEnd("try");
                     $count1 =  $ftupLen;
                    
                }
                                
                elsif($ftuple[$count1][1] eq "IL"){$operation = 13;}
                elsif($ftuple[$count1][1] eq "CJUMPF"){$operation = 14;}
                
                elsif($ftuple[$count1][1] eq "JUMP"){$operation = 16;}
                
                
                
                elsif($ftuple[$count1][1] eq "ENDOFCALL"){$operation = 20;}
                elsif($ftuple[$count1][1] eq "ACTUALPARAMETER"){$operation = 21;}
                
                
                elsif($ftuple[$count1][1] eq "ENDOFEXECUTION")
                {
                    $operation = 22; 
                }
                
                
                elsif($ftuple[$count1][1] eq "refACTUALPARAMETER"){$operation = 23;}
                            
                
                print "OPERATION: $operation \n";
    $count1++;
    
    

}

        
    open (PRAGTUPLE, ">$pragFTuple") or die "Cant find the specified file: $!\n";
	
	for my $out2 (@pragftuple)
	{
		print PRAGTUPLE "$out2\n";
	}
	
	close (PRAGTUPLE);
    
