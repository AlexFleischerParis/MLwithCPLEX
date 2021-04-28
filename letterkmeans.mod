using CP;

tuple datatype
{
  string label;
  
  int f1;
  int f2;
  int f3;
  int f4;
  int f5;
  int f6;
  int f7;
  int f8;
  int f9;
  int f10;
  int f11;
   int f12;
  int f13;
  int f14;
  int f15;
  int f16;
}

{datatype} data=...;

{string} labels={i.label | i in data};

execute
{
  cp.param.timelimit=600;
}



int m=26;
range M=1..m;

int dimensions=16;
range dim=1..dimensions;



int point[i in data][j in dim];

execute
{
  for(var i in data)
  {
    point[i][1]=i.f1;
    point[i][2]=i.f2;
    point[i][3]=i.f3;
    point[i][4]=i.f4;
    point[i][5]=i.f5;
    point[i][6]=i.f6;
    point[i][7]=i.f7;
    point[i][8]=i.f8;
    point[i][9]=i.f9;
    point[i][10]=i.f10;
    point[i][11]=i.f11;
    point[i][12]=i.f12;
    point[i][13]=i.f13;
    point[i][14]=i.f14;
    point[i][15]=i.f15;
    point[i][16]=i.f16;
  }
}



int scale=1;

// which centers for clusters




// which centers for clusters
dvar int scalecx[M][dim] in 0..scale*20;

dexpr int cx[i in M][d in dim]=scalecx[i][d];

// which cluster for each point
dvar int x[data] in M;

// distance from points to cluster center
dexpr int d[i in data]=sum(j in dim) (cx[x[i]][j]-point[i][j])*(cx[x[i]][j]-point[i][j]);

// total distance
dexpr int totald=sum(i in data) d[i];
minimize totald;
subject to
{
  //forall(i in data) x[i]==ord(labels,i.label)+1;
}  

int confusionmatrix[m in M][l in labels]=sum(i in data:l==i.label) (x[i]==m);

int rightModeQuantity[l in labels]=max(m in M) confusionmatrix[m][l];

execute
{
  writeln("confusion matrix = ",confusionmatrix);
}

float accuracy=1/card(data)*sum(l in labels) rightModeQuantity[l];

execute
{
  writeln("accuracy = ",accuracy);
}

/*

which gives

// solution with objective 1.317733e+7
confusion matrix =  [[748 524 760 688 743 729 730 756 715 732 678 718 737 752 710 703 725 673 781
         725 706 746 760 768 718 640]
         [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
         [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
         [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
         [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
         [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
         [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
         [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
         [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
         [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
         [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
         [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
         [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
         [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
         [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
         [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0]
         [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0]
         [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
         [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
         [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
         [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0]
         [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
         [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
         [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
         [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
         [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]]
accuracy = 0.999839297

*/