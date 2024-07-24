#include <stdio.h>
#include <string.h>
#include <time.h>
#include "UN2000_order.h"

void GetData(int no, char *msg)
{
	char	function;
	char	sid[12];
	char	*packet;
	char	*end;
	char	seq[4];

	function = msg[2];
	packet = msg;
	end = strchr(packet, CR);
	*end = '\0';

//Query
	if (function == 'Q') {

		ParseDelimiter(packet, 2, '|', seq);
		ParseDelimiter(packet, 3, '|', sid);
		TrimSpace(sid);
		strtok(sid, "\"* /:<>?\\|");
					
		WriteBuffer(no, seq, sid);
	}
}