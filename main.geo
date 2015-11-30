//gmsh 

box = 1;
bound = 3;
grid = 0.1;
disp = 0.1;


ce = 0;
pts[] = {};
Point(ce++) = {box, box, 0, grid};pts[]+=ce;corner =ce;
Point(ce++) = {-box, box, 0, grid};pts[]+=ce;
Point(ce++) = {-box, -box, 0, grid};pts[]+=ce;
Point(ce++) = {box, -box, 0, grid};pts[]+=ce;

lns[] = {};
Line(ce++) = {pts[0], pts[1]};lns[]+=ce;
Line(ce++) = {pts[1], pts[2]};lns[]+=ce;
Line(ce++) = {pts[2], pts[3]};lns[]+=ce;
Line(ce++) = {pts[3], pts[0]};lns[]+=ce;

Line Loop(ce++) = lns[];
inner = ce;

pts[] = {};
Point(ce++) = {bound, bound, 0, grid};pts[]+=ce;
Point(ce++) = {-bound, bound, 0, grid};pts[]+=ce;
Point(ce++) = {-bound, -bound, 0, grid};pts[]+=ce;
Point(ce++) = {bound, -bound, 0, grid};pts[]+=ce;

lns[] = {};
Line(ce++) = {pts[0], pts[1]};lns[]+=ce;
Line(ce++) = {pts[1], pts[2]};lns[]+=ce;
Line(ce++) = {pts[2], pts[3]};lns[]+=ce;
Line(ce++) = {pts[3], pts[0]};lns[]+=ce;

Line Loop(ce++) = lns[];
outer = ce;

Ruled Surface(ce++) = {outer, inner};
ex = ce;







Function generateArray//From n; Get series[];
	series[]={};
	For k In {0:n-1}
		series[k]=1;
	EndFor
Return
Function generateGeometricSeries//From r,n,lt; Get series[];
	series[]={};
	sum=0;
	For k In {0:n-1}
		sum+=r^k;
	EndFor
	//Printf("Series:");
	sum2=0;
	For k In {0:n-1}
		sum2+=r^k;
		series[k]=sum2/sum;
		//Printf("%g",series[k]);
	EndFor
Return
Function myExtrusion//From b=;l=;c=;p=; Get surf[];vol;newbase;
	n=c;
	Call generateArray;
	a[]=series[];
	s[]=a[];
	If(p!=1)
		r=p;n=c;lt=l;Call generateGeometricSeries;
		s[]=series[];
	EndIf
	If(p==1)
		ids[]=Extrude {0, 0, l} {
		   	Surface{b};
		   	Layers{c};
		 	Recombine;
		};
	EndIf
	If(p!=1)
		ids[]=Extrude {0, 0, l} {
			Surface{b};
			Layers{a[],s[]};
		   	Recombine;
		};
	EndIf
	extremeLengths[]={s[1]-s[0],s[#s[]-1]-s[#s[]-2]};
	maxLength=extremeLengths[1];
	minLength=extremeLengths[0];
	If(extremeLengths[0]>extremeLengths[1])
		maxLength=extremeLengths[0];
		minLength=extremeLengths[1];
	EndIf
	//Printf("extremeLengths: %g %g",extremeLengths[0],extremeLengths[1]);
	newbase=ids[0];
	vol=ids[1];
	surf[]=ids[{2:#ids[]-1}];
	ce+=10000;
Return





b=ex;
l=1;
c=20;
p=0.9;
Call myExtrusion;

lns[] = Boundary{Surface{newbase};};
corners = Boundary{Line{lns[4]};};


Translate {0, 0, -disp} { Point{corners[0]}; }
