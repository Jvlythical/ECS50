#include <iostream>
#include <cmath>

#include "MyFloat.h"

using namespace std;

void MyFloat::unpackFloat(float f)
{
	__asm__(
			"movl %[f], %[sign];"
			"shrl $31, %[sign];"
			"movl %[f], %[exponent];"
			"shll $1, %[exponent];"
			"shrl $24, %[exponent];"
			"movl %[f], %[mantissa];"
			"shll $9, %[mantissa];"
			"shrl $9, %[mantissa]":
			[sign] "=r" (sign), [exponent] "=r" (exponent), [mantissa]  "=r" (mantissa): //outputs
			[f] "r" (f):								//inputs
			"cc"									  //clobber
			);
}


MyFloat::MyFloat(){
	sign = 0;
	exponent = 0;
	mantissa = 0;
}

MyFloat::MyFloat(float f){
	unpackFloat(f);
}

MyFloat::MyFloat(const MyFloat & rhs){
	sign = rhs.sign;
	exponent = rhs.exponent;
	mantissa = rhs.mantissa;
}

ostream& operator<<(std::ostream &strm, const MyFloat &f){
	strm << f.packFloat();
	return strm;

}




MyFloat MyFloat::operator+(const MyFloat& rhs) const{
	unsigned int rexp_1 = exponent - 127, mant_1 = mantissa + pow(2, 23);
	unsigned int rexp_2 = rhs.mantissa - 127, mant_2 = rhs.mantissa + pow(2, 23);

	if(rexp_1 < rexp_2) {
		int diff = rexp_2 - rexp_1;

		mant_2 = mant_2 * pow(2, diff);
		exponent = rexp_2;
	} else {
		int diff = rexp_1 - rexp_2;

		mant_1 = mant_1 * pow(2, diff);
	}
	
	
	mantissa = mant_1 + mant_2;

	if(carryWouldHappen(mant_1, mant_2)) {
		mantissa = mantissa / 2;
		++exponent;
	}

	return *this;
}


float MyFloat::packFloat() const{
	//returns the floating point number represented by this
	float f = 0;

	asm (
			"movl 	%[mantissa], %[f];"
			"shll 	$23, %[exponent];"
			"shll 	$31, %[sign];"
			"orl  	%[exponent], %[f];"
			"orl  	%[sign], %[f]"

			// Outputs
			: [f] "=r" (f)
			// Inputs
			: [sign] "r" (sign), [exponent] "r" (exponent), [mantissa] "r" (mantissa)
			// Clobbered register
			:
			);

	//returns the floating point number represented by this

	return f;
}//packFloat
//

bool MyFloat::carryWouldHappen(unsigned int a, unsigned int b){
	bool carry = false;
	__asm__(
			"add %[b], %[a];"
			"jnc nocarry;"
			"movl $1, %%eax;"
			"jmp done;"
			"nocarry:;"
			"movl $0, %%eax;"
			"done:;"
			"movl %%eax, %%eax":
			[carry] "=r" (carry):			//outputs
			[a] "r" (a), [b] "r" (b):	//inputs
			"cc"											//clobber
			);
	return carry;
}//carryWouldHappen


