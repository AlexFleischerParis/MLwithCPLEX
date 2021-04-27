using CP;

tuple datatype
{
  int rank;
  float f1;
  float f2;
  float f3;
  float f4;
  string label;
}

{datatype} data;

// Parse csv file
execute {
    var f = new IloOplInputFile("iris.data");
    var rank = 1;
	var str;
	var ar;
	var N=4;
    while (!f.eof) {
		str = f.readline();
		//writeln(str);
		var ar = str.split(";");
		if (ar.length>=N+1) 
			data.add(rank,ar[0], ar[1], ar[2], ar[3], ar[4]); // ==> As many fields as needed
		rank++;
    }
    f.close();
//	writeln(s);
	writeln(rank);
}

{string} labels={i.label | i in data};

execute
{
  cp.param.timelimit=60;
}



int m=3;
range M=1..m;

int dimensions=4;
range dim=1..dimensions;



float point[i in data][j in dim]=(j==1)?i.f1:((j==2)?i.f2:
(j==3)?i.f3:i.f4);



int scale=10;

// which centers for clusters
dvar int scalecx[M][dim] in 0..scale*10;

dexpr float cx[i in M][d in dim]=scalecx[i][d]/scale;

// which cluster for each point
dvar int x[data] in M;

// distance from points to cluster center
dexpr float d[i in data]=sum(j in dim) (cx[x[i]][j]-point[i][j])^2;

// total distance
dexpr float totald=sum(i in data) d[i];
minimize totald;
subject to
{
  
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

// solution with objective 87.53
matrix =  [[0 3 39]
         [0 46 11]
         [50 1 0]]
accuracy = 0.9

*/

