Part I
1.

proc nlmixed data=ABI.billboard;
  parms r=1 alpha=1;
  ll = peoplecount*log((GAMMA(r+exposures))/(GAMMA(r)*fact(exposures))*((alpha/(alpha+1))**r)*((1/(alpha+1))**exposures));
  model peoplecount ~ general(ll);
run;

2.

proc nlmixed data=ABI.kc;
  /* m stands for lambda */
  parms m0=1 b1=0 b2=0 b3=0 b4=0;
  m=m0*exp(b1*income+b2*sex+b3*age+b4*HHSize);
  ll = total*log(m)-m-log(fact(total));
  model total ~ general(ll);
run; 

3.

proc nlmixed data=ABI.kc;
  parms r=1 a=1 b1=0 b2=0 b3=0 b4=0;
  expBX=exp(b1*income+b2*sex+b3*age+b4*HHSize);
  ll = log(gamma(r+total))-log(gamma(r))-log(fact(total))+r*log(a/(a+expBX))+total*log(expBX/(a+expBX));
  model total ~ general(ll);
run;

Part II

1.

proc import datfile = 'D:\SAS workbook\ABI\book.txt' out=books dbms=tab replace;
 getnames=yes;
run;

data books;
set books;
if region='*' then region='3';
if age='99' then age='6';
if education='99' then education='6';
run;

Proc SQL;
create table temp1 as
select distinct userid, sum(qty) as quantity, education, hhsz, income,age, child, race,country, domain
from books
where domain = 'barnesandn'
group by userid, domain;
create table temp2 as
select distinct userid, 0 as quantity, education, hhsz, income, age, child, race,country, domain
from books
where userid not in (select distinct userid from books where domain = 'barnesandn');
quit;

data BN;
merge temp1 temp2;
by userid;
run;

2.

proc sql;
create table BNcount as 
 select quantity, count(userid) as peoplecount
from BN
 group by quantity;
quit; 

proc nlmixed data=BNcount;
  parms r=1 alpha=1;
  ll = peoplecount*log((GAMMA(r+quantity))/(GAMMA(r)*fact(quantity))*((alpha/(alpha+1))**r)*((1/(alpha+1))**quantity));

  model peoplecount ~ general(ll);
run;

4.

proc nlmixed data=BNcount;
  parms r=1 alpha=1;
  ll = peoplecount*log((GAMMA(r+quantity))/(GAMMA(r)*fact(quantity))*((alpha/(alpha+1))**r)*((1/(alpha+1))**quantity));

  model peoplecount ~ general(ll);
run;

