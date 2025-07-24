#include <stddef.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head) {
    /* your code here */
	node *tortoise, *hare;
	tortoise  = head;
	hare = head;
	while (hare) {
		if ((*hare).next)
			hare = (*hare).next -> next;
		else 
			return 0;
		tortoise = (*tortoise).next;
		if (tortoise == hare)
			return 1;
	}	
    return 0;
}
