$ontext
Created by Omar Alminagorta
Supervised by Dr. David Rosenberg
Utah Water Research Laboratory
Civil and Environmental Engineering Departament
Utah State University
May-2011

This is a simple model to select the Best Management Practice(BMPs) to reduce phosphorus load in a watershed. The model tries to reach
specific targets (i.e., water quality standards)and considers economic and efficiency factors to recommends BMPs.
This model is applied at the Echo Reservoir, Utah and it is defined as following:

- Objective function: Minimize Cost of BMP implementation
- Decision Variable: Area to implement the BMP
- Constraints: Area or Lenght Available


g represent the available Resources
Agric Land(km2)               1,3,4,5
Grass filter strips (km2)       2
Grazing Land(km2)               6
Stream Bank(Km)                 7
Stream Fences (Km)              8
Manure System(System)           9


s1  Land Applied Manure
s2  Private Land Grazing
s3  Diffuse Run-off

w1  Chalk Creek
w2  Weber River below Wanship
w3  Weber River above Wanship

BMP
1        Land retirement
2        Grazing land protection
3        Stream fencing
4        Stream bank stabilization
5        Cover crops
6        Grass filter strips
7        Animal waste facility
8        Conservation tillage
9        Agricultural nutrient management
10        Sprinkler irrigation

More details see the published manuscript at: http://ascelibrary.org/doi/abs/10.1061/%28ASCE%29WR.1943-5452.0000224
or the second Chapter of my Thesis at : http://digitalcommons.usu.edu/etd/4375/

If you use the model or part of the code, cite as:
"Alminagorta, O., B. Tesfatsion, D. Rosenberg, and B. Neilson (2012),
Simple Optimization Method to Determine Best Management Practices to Reduce Phosphorus Loading in Echo Reservoir, Utah,
 Journal of Water Resources Planning and Management, 139(1), 122-125."

If you have any question or you want to see more system models check my website: https://sites.google.com/a/aggiemail.usu.edu/omar-alminagorta-cabezas/home

Licensing:

Copyright (c) 2014, Omar Alminagorta and David E. Rosenberg
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its
  contributors may be used to endorse or promote products derived from
  this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

$offtext


set i BMPs / BMP1,BMP2,BMP3,BMP4, BMP5,BMP6,BMP7, BMP8, BMP9, BMP10/
    s Source of N / s1,s2,s3/
    w Subwatershed  /w1, w2, w3/
    g row to generate the inplementation matrix /1*9/
;


Table target(w,s)

              S1            S2                s3
w1          768.80        353.50            915.46
w2          753.60        155.00            549.30
w3         2848.00        371.80           1351.70

*Existing Total Watershed Load (kg/year)
Table ExisLoad(w,s)

          S1          S2          s3
w1        961        3535        6539
w2        942        1550        5493
w3        3560       3718        13517

;

Table area_availa (g,w)
*In the row 1: means that in subwatershed1 (W1), There are only 15.6Km2 of Available Agricultural Area

          W1          W2          W3
1        15.6        24.5        69.8
2        3.5         1.8         3.5
3        15.6        24.5        69.8
4        15.6        24.5        69.8
5        15.6        24.5        69.8
6       311.8        95.3       229.4
7        70.0        36.0        70.0
8        70.0        36.0        70.0
9         0.0         0.0         0.0

;

Parameter ef(i) reduccion of P in Kg per year
/
BMP1        184.94
BMP2        21.74
BMP3        23.81
BMP4        208.34
BMP5        43.71
BMP6        143.47
BMP7        27106.66
BMP8        20.18
BMP9        43.71
BMP10       2914.21
/;

Parameter cost(i)   dollars-kg

/
BMP1        7367.85
BMP2        238.10
BMP3        1373.48
BMP4        15.43
BMP5        674.61
BMP6        412.26
BMP7        729.73
BMP8        337.31
BMP9        167.55
BMP10       127.87
/
;

Variables

Areaused(i,w,s) area to be used by BMP
P(i,w,s) phosporus removed
obj
;
Positive Variables
Areaused, P;

table E(g,i)  Exclusion matrix for row

        BMP1    BMP2    BMP3    BMP4     BMP5   BMP6   BMP7    BMP8   BMP9   BMP10
1        1                                1
2                                                1
3        1                                                      1
4        1                                                              1
5        1                                                                     1
6                1
7                        1
8                                1
9                                                        1
;

table C(i,s)  Binary parameter 1 if BMP can be applied to source s

            s1      s2       s3
BMP1        0        0        1
BMP2        0        1        0
BMP3        0        1        0
BMP4        0        0        1
BMP5        0        0        1
BMP6        1        1        1
BMP7        0        0        0
BMP8        1        0        1
BMP9        1        0        1
BMP10       0        0        1
;


Equations
Effic(i,w,s)
Request(w,s)
**Request(s)
Are(g,w)
ExistingLoad(w,s)
Objective
;

*Quantity of Phosphorus removed by BMP in Kg/yr
Effic(i,w,s)..   P(i,w,s) =e=ef(i)*Areaused(i,w,s);

* Meet Removal Target
* Request(w,s) is for scenario 1 : Simple Analyzis, Request(s) is for scenario 2(global analysis)
Request(w,s)..
*Request(s)..
*        sum((i,w),P(i,w,s)*C(i,s)) =g= sum(w,target(w,s));
     sum(i,P(i,w,s)*C(i,s)) =g= target(w,s);

* Available Resources
Are(g,w)..
         sum((s,i),(C(i,s)*E(g,i)*Areaused(i,w,s)))=l= area_availa(g,w);


*constraint to get result lower than existing load  C(i,s) represented the source matrix
ExistingLoad(w,s)..

          sum((i),P(i,w,s)*C(i,s)) =l= ExisLoad(w,s);

Objective..  obj=e= sum((i,w,s),(P(i,w,s))*cost(i));



option limrow = 140 ;
Model WaterQuality /all/ ;

Solve WaterQuality USING LP Minimizing obj ;
Display Obj.l;






