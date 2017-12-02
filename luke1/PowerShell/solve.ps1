#! /usr/bin/env pwsh

#$perm = "aeteesasrsssstaesersrrsse";
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

    $len
    $stats
}

$words = @("snowflake", "mistletoe");

$words | % {
    for ($i = 2; $i -lt 5; $i++) {
       $ngram = N-Gram $_ $i 
       Write-Host "`n$($_), len $($_.Length), n = $($i): $ngram"
       Stats $ngram
    }
}

return

N-Gram "snowflake" 2
return

@($word1, $word2) | % {
    $perm = $_;
}


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