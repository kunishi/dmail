#
# $Id: getdistopt.awk,v 1.4 2000/01/04 08:49:27 kunishi Exp $
#

BEGIN {
    eoh=0;
    cntln=0;
    subject="";
}
/^Subject:/ && eoh == 0 {
    cntln=1;
    subject=$0;
    next;
}
/^[ 	]/ && cntln == 1 {
    subject = sprintf("%s%s", subject, $0);
    next;
}
{ cntln = 0; }
/^$/ && eoh == 0 {
    eoh = 1;
}
END {
    while (match(subject, "\[[a-zA-Z0-9]+\]")) {
	if (substr(subject, RSTART+1, RLENGTH-2) != mlname) {
	    printf("%s ", substr(subject, RSTART, RLENGTH));
	}
	subject = substr(subject, RSTART+RLENGTH);
    }
}
