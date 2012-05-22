#
# $Id: processheader.awk,v 1.8 2002/06/24 09:59:48 kunishi Exp $
#
# Note:
#  This script assumes that some variables are assigned from the outside
#  of the script (ex. using -v option.).  Here is the list of the variables:
#     $maildist
#       sub ML options list.
#       Each option is assumed to be enclosed by square brackets ([]), 
#       and is separated by a space character.
#     $mlname
#       The name of the ML.
#     $owner
#       The owner of the ML (envelope-from of the distributed mail)
#     $mladdress
#       The address of the ML
#

BEGIN {
    rcvd = 0; eoh = 0; subj = ""; cont = 0;
}
/^Received:/ {
	rcvd = 1; next;
}
/^[ 	]/ && rcvd == 1 {
	next;
}
{ rcvd = 0; }
/^Subject:/ && eoh == 0 {
    sub("^Subject:[ 	]+", "");
    subj = $0;
    cont = 1; next;
}
/^[ 	]/ && cont == 1 {
    subj = sprintf("%s%s", subj, $0); next;
}
cont == 1 {
    sub(sprintf("(\\[%s\\] )+", mlname), "", subj);
    gsub("((Re|re|RE):[ 	]+)+", "Re: ", subj);
    gsub("[ 	]+", " ", subj);
    printf("Subject: [%s] %s\n", mlname, subj);
}
{ cont = 0; }
/^Return-Path:/ && eoh == 0 {
    next;
}
/^Return-Receipt-To:/ && eoh == 0 {
    next;
}
/^Reply-To:/ && eoh == 0 {
    next;
}
/^Errors-To:/ && eoh == 0 {
    next;
}
/^X-ML-Name:/ && eoh == 0 {
    next;
}
/^$/ && eoh == 0 {
    printf("X-ML-Name: %s\n", mlname);
    printf("Errors-To: %s\n", owner);
    printf("Reply-To: %s\n", mladdress);
    eoh = 1; print; next;
}
{print;}
