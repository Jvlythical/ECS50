#include <cmath>

float sum(int exp1, int mant1, int exp2, int mant2) {
	unsigned int rexp_1 = exp1 - 127, mant_1 = mant1 + pow(2, 23);
	unsigned int rexp_2 = exp2 - 127, mant_2 = mant2 + pow(2, 23);

	if(rexp_1 < rexp_2) {
		int diff = rexp_2 - rexp_1;

		mant_2 = mant_2 * pow(2, diff);
	} else {
		int diff = rexp_1 - rexp_2;

		mant_1 = mant_1 * pow(2, diff);
	}
	
	//if(carryWouldHappen(mant_1, mant_2)) ++exp;
	
	int mantissa = mant_1 + mant_2;

	return mantissa;
}

int main() {
	float s = sum(127, 1, 127, 1);

	return 0;
}
