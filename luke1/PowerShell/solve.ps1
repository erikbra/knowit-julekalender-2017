#! /usr/bin/env pwsh

$perm = "aeteesasrsssstaesersrrsse";
$word1 = "misiststltleletetotoe"
$word2 = "snnoowwffllaakke"
$wordList = ".\wordlist.txt";

function N-Gram ($word, $n) {
   $chars = $word.ToCharArray();
   $ngram = @();
   for ($i = 0; $i -lt $chars.Count -$n + 1; $i++) {
      $end = $i + $n -1
      $ngram += $chars[$i..$end];
   } 
   $ngram -join ""
}

function Stats ($ngram) {
    $chars = $ngram.ToCharArray();
    $sorted = (($chars | Sort-Object))
    $len = $ngram.Length

    $stats = ($sorted | Group | Sort-Object -Property Count)

    $stats
}

$words = @("snowflake", "mistletoe");
$words = @("abcdefghi");
$words = @();

$words | % {
    $maxLen = [Math]::Pow([Math]::Round(1.00 * $_.Length / 2), 2);

    for ($i = 1; $i -lt 10; $i++) {
       $ngram = N-Gram $_ $i 
       Write-Host "`n$($_), len $($_.Length), n = $($i): $ngram"
       Stats $ngram
    }
}

function Partition([int] $n, $max, $used) {
    $parts = @()
    if ($n -eq 0) {
        return $parts;
    }

    for ($i = 1; $i -le $max; $i++) { 
        [int] $other = $n - $i 
        Write-Host "n: $n, max: $max, i: $i, other: $other"
        $used[$i]+=1;
        #"used i = $($used)"
        #if ($used[$i] -ge 2) {
            #"Continuing - used i = $($used[$i])"
            #return $parts
        #}
        $newMax = $(([int]$other)/2) 
        $parts += "$n + $(Partition $($other) $newMax $used)"
   }
   return $parts
}

[int[]] $used = new-object int[] 6
Partition 3 3 $used  | Select-Object
return

$perms = @("abcdebcdefcdefgdefghefghi", $perm);

$perms | % {
    $permLen = $($perm.Length);
    "Perm len: $($permLen)"

    $middle = [Math]::Sqrt($permLen)

    if ($permLen % 2 -eq 0) {
        $len = $middle * 2;
    } else {
        $len = $middle * 2 - 1;
    }

    "`nWord len: $($len)"
    Stats $_ | % {
        $combinations = Partition $_.Count $middle
        "$($_.Name): $($combinations -join ', ')"
    }
}

return


$unique = $sorted | Get-Unique

if (!(Test-Path $wordList)) {
    Invoke-WebRequest -UseBasicParsing -OutFile $wordList https://s3-eu-west-1.amazonaws.com/julekalender-knowit-2017-vedlegg/wordlist.txt
}
$wordFile = (Get-Item $wordList);

# $wordFile | Get-Content | Select -First 10

$candidates = @();

$cmd = "& Get-Content $($wordList)";

$unique | % {
    $cmd += " | Select-String $($_)";
}

echo "$($cmd)";
Invoke-Expression $($cmd);

#$unique