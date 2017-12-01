#! /usr/bin/env/pwsh

#$perm = "aeteesasrsssstaesersrrsse";
$word1 = "misiststltleletetotoe"
$word2 = "snnoowwffllaakke"
$wordList = ".\wordlist.txt";


@($word1, $word2) | % {
    $perm = $_;

$chars = $perm.ToCharArray();
$sorted = (($chars | sort))
$len = $perm.Length

$stats = ($sorted | Group | Sort -Property Count)

$len
$stats

}
return;

$unique = (($chars | sort)) | Get-Unique

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