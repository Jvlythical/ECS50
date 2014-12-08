#include "MyFloat.h"
#include<iostream>

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


