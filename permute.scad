/*----------------------------------------------------------------------
Permute © 2026 by Philip Nye is licensed under CC BY-SA 4.0.
To view a copy of this license, visit 
https://creativecommons.org/licenses/by-sa/4.0/ 

#tabs=4s
----------------------------------------------------------------------*/

/*----------------------------------------------------------------------
function permute(list)

Recursive function returning a superlist containing a sublist for every 
possible permutation of the items in the original list.

e.g permute(["A", "B", "C"]) returns
[
    ["A", "B", "C"],
    ["A", "C", "B"],
    ["B", "C", "A"],
    ["B", "A", "C"],
    ["C", "A", "B"],
    ["C", "B", "A"]
]

WARNING - only use on very short lists. For a list of N items there are 
factorial(N) permutations. Just 5 items will return 120 permutations 
(120 sub-lists of 5 items). For a list with ten items that number is 
well over 3 million!
----------------------------------------------------------------------*/
$permute_max = 8;

function permute(list) = let(n = len(list))
    assert(n <= $permute_max, "Too many permutations!")
    n <= 1 ? list : [
        for (i = [0:n - 1], item = permute(rotateOmit(list, i))) concat([list[i]], item)
    ];

/*----------------------------------------------------------------------
function rotateOmit(list, i)

Returns a list rotated to position i and with that item removed. This 
retains cyclic order.

e.g. rotateOmit(["A", "B", "C", "D"], 2) returns ["D", "A", "B"]

This performs no checking that its arguments make sense
----------------------------------------------------------------------*/
function rotateOmit(list, omit) =
    let(n = len(list))
    [for (i = [1:n - 1]) list[(omit + i) % n]];

/*
Testing

testList = [1, 2, 3, 4, 5];
perms = permute(testList);
for (perm = perms) echo(perm);
echo(str(len(perms), " permutations"));
*/
