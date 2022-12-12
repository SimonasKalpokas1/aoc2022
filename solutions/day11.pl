#!/usr/bin/perl
  
use strict;
use warnings;

use integer;

  
open(FH, '<', '../inputs/day11.txt') or die $!;

my @items = ();
my @opers = ();
my @tests = ();
my @trues = ();
my @falss = ();

my $product = 1;

my $n = 0;
while(<FH>){
    chomp $_;
    if (not rindex($_, 'Monkey ', 0)) {
        $n = $n + 1;
    } elsif (index($_, 'Starting items:') != -1) {
        my @nums = $_ =~ /(\d+)/g;
        push (@items, \@nums)
    } elsif (index($_, 'Operation:') != -1) {
        my @nums = $_ =~ /(\d+)/g;
        if (index($_, '*') != -1) {
            if (scalar @nums == 0) {
                push (@opers, sub { return $_[0] * $_[0]; })
            } else {
                push (@opers, sub { return $nums[0] * $_[0]; })
            }
        } elsif (index($_, '+') != -1) {
            if (scalar @nums == 0) {
                push (@opers, sub { return $_[0] + $_[0]; })
            } else {
                push (@opers, sub { return $nums[0] + $_[0]; })
            }
        }
    } elsif (index($_, 'Test:') != -1) {
        my @nums = $_ =~ /(\d+)/g;        
        push (@tests, $nums[0]);
        $product = $product * $nums[0];
    } elsif (index($_, 'If true') != -1) {
        my @nums = $_ =~ /(\d+)/g;
        push (@trues, $nums[0]);
    } elsif (index($_, 'If false') != -1) {
        my @nums = $_ =~ /(\d+)/g;
        push (@falss, $nums[0]);
    }
}
close(FH);

my @items_copy = map { [@$_] } @items;

my @part1 = (0) x $n;
for (0..19) {
    foreach my $i (0..$n-1) {
        foreach my $item (@{$items[$i]}) {
            $part1[$i] = $part1[$i] + 1;
            my $new_level = ($opers[$i]) -> ($item)/3;
            if ($new_level % $tests[$i] == 0) {
                push (@{$items[$trues[$i]]}, $new_level);
            } else {
                push (@{$items[$falss[$i]]}, $new_level);
            }
        }
        @{$items[$i]} = ();
    }
}
@part1 = sort { $a <=> $b } @part1;
print "Part 1: ", $part1[$n-2] * $part1[$n-1], "\n";

my @part2 = (0) x $n;
for (0..9999) {
    foreach my $i (0..$n-1) {
        foreach my $item (@{$items_copy[$i]}) {
            $part2[$i] = $part2[$i] + 1;
            my $new_level = ($opers[$i]) -> ($item) % $product;
            if ($new_level % $tests[$i] == 0) {
                push (@{$items_copy[$trues[$i]]}, $new_level);
            } else {
                push (@{$items_copy[$falss[$i]]}, $new_level);
            }
        }
        @{$items_copy[$i]} = ();
    }
}
@part2 = sort { $a <=> $b } @part2;
print "Part 2: ", $part2[$n-2] * $part2[$n-1], "\n";
