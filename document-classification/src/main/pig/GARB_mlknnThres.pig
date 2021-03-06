--
-- (C) 2010-2012 ICM UW. All rights reserved.
--

DEFINE buildModel(part,DEF_NEIGH) RETURNS ret{
	split $part into 
		posX if (categA == categQ
				and categB == categQ), -- keyA, keyB, categA, categB, part, categQ; 
		negX if (categA != categQ
				and categB == categQ); -- keyA, keyB, categA, categB, part, categQ;

	pos = calcCategNeighDocs(posX); --(categ),{(categ,count,docscount)}
	neg = calcCategNeighDocs(negX);

	allX6 = join pos by $0,neg by $0; -- (categPOS),POS::{(categ,count,docscount)}, (categNEG),NEG::{(categ,count,docscount)}?
	$ret = foreach allX6 generate FLATTEN(pl.edu.icm.coansys.classification.
		documents.pig.proceeders.THRES_FOR_CATEG(*,$DEF_NEIGH)) 
		as (categ:chararray, thres:int, f1:double);
};

DEFINE calcCategNeighDocs(tab) RETURNS ret{
	tabX2 = group $tab by (keyA, categA); -- (keyA,categA), {(keyA, keyB, categA, categB, tab, categQ)}; np. 3 sąsiadów ma categB==categA
	tabX3 = foreach tabX2 generate group.categA as categ, COUNT($tab) as neigh; -- categ, 3;
	tabX4 = group tabX3 by (categ,neigh); -- (categ,count),{(categ,count)}; 
	tabX5 = foreach tabX4 generate flatten(group), COUNT(tabX3) as docsocc; -- np kod 12345 wystąpił u 3 sąsiadów w 5 dokumentach
	tabX5A = order tabX5 by neigh asc;
	$ret = group tabX5 by categ; --(categ),{(categ,count,docscount)}
};

DEFINE classify(model,data) RETURNS ret{
	posX = filter $data by categB == categQ;  -- keyA, keyB, categB, categQ; 
	posXGR = group posX by (keyA,categB);
	pos = foreach posXGR generate group.keyA as key,group.categB as categ, COUNT(posX) as occ;

	classifX = join pos by categ, model by categ; --key, categ, occ, key, thres, f1;
	classifT = filter classifX by thres<=occ;
	$ret = foreach classifT generate key, model::categ;
};
