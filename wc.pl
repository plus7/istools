#!/usr/bin/perl -w
#-- -*- encoding: utf-8 -*- --
# 原著作者不明
open( OUT, "| wc -w" );
while ( $#ARGV >= 0 ) {
    my $file = shift @ARGV;

    #  print "$file\n";
    open( IN, "<$file" );
    while (<IN>) {
        if ( /begin/ && /jabstract/ ) {
            do { $_ = <IN>; } while ( !( /end/ && /jabstract/ ) );
        }
        s/\%.*//g;
        s/\\textit\{(.*?)\}/$1/g;
        s/\\footnote\{(.*?)\}/$1/g;
        s/\\includegraphics\[.*?\]\{.*?\}//g; # includegraphicsのオプション指定部に半角スペースがあるとおかしくなるのを直した 2012/01/30
        s/\\[^\s\{]*\{[^\}]*\}//g;    # \begin{center}
        s/\\[^\s]*//g;                # \alpha
        s/\[[^\]]*\]//g;              # \begin{figure}[htb]
        s/\_[^\s]+//g;
        s/\^[^\s]+//g;
        s/[:\!\~]+//g;
        s/[\{\}\&\$\-\+\(\)=<>\.\,\[\]]+/ /g;
        print OUT;
    }
    close(IN);
}
close(OUT);
