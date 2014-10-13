#include <stdio.h>
#include <search.h>
#include <assert.h>

extern const char *const keys[];
extern const size_t nr_keys;
extern const char *const values[];
extern const size_t nr_values;

const char *multilang(const char *key)
{
	static unsigned char initialized = 0;
	int i;
	ENTRY e, *ep;

	if (!initialized) {
		/* the # of elements in keys must be equal to that in values */
		assert(nr_keys == nr_values);
		hcreate(nr_keys);

		for (i = 0; i < nr_keys; i++) {
			e.key = keys[i];
			e.data = values[i];
			ep = hsearch(e, ENTER);
			/* there should be no failures */
			if (ep == NULL) {
				fprintf(stderr, "entry failed\n");
				return key;
			}
		}

		initialized = 1;
	}

	e.key = key;
	ep = hsearch(e, FIND);

	if (ep == NULL) {
		fprintf(stderr, "find failed, key: %s\n", key);
		return key;
	} else {
		return ep->data;
	}
}
