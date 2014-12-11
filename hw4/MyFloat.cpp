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

	if (mantissa == rhs.mantissa && exponent == rhs.exponent && sign != rhs.sign)	//opposite but equal case
	{
			this.exponent == 0;
			this.mantissa == 0;
			return *this;
	}

	if ((exponent !=0 && mantissa != 0) && (rhs.exponent == 0 && rhs.mantissa == 0))	//if rhs == 0
	{
			return *this;
	}

	else if ((exponent==0 && mantissa == 0) && (rhs.exponent != 0 && rhs.mantissa !=0))		//if lhs == 0
	{
			this.sign = rhs.sign;
			this.exponent = rhs.exponent;
			this.mantissa = rhs.mantissa;
			return *this;
	}

	if(rexp_1 < rexp_2) {
		int diff = rexp_2 - rexp_1;
		if (diff <= 8)												//if diff <=8, left shift mantissa of larger number
			mant_2 = mant_2 * pow(2, diff);
		else
			mant_1 = mant_1 / pow(2, diff);			//if diff > 8 right shift mantissa of smaller number
		exponent = rexp_2;
	} 
	else {
		int diff = rexp_1 - rexp_2;
		if (diff <= 8)
			mant_1 = mant_1 * pow(2, diff);
		else
			mant_2 = mant_2 / pow(2,diff);
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


