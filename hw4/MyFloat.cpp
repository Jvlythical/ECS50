#include <iostream>
#include "MyFloat.h"

using namespace std;

void MyFloat::unpackFloat(float f)
{
	__asm__(
			"movl 	%[f], %[sign];"
			"shrl 	$31, %[sign];"
			"movl 	%[f], %[exponent];"
			"shll 	$1, %[exponent];"
			"shrl 	$24, %[exponent];"
			"movl 	%[f], %[mantissa];"
			"shll 	$9, %[mantissa];"
			"shrl 	$9, %[mantissa]" 
		// Outputs
			: [sign] "=r" (sign), [exponent] "=r" (exponent), [mantissa] "=r" (mantissa) 
		// Inputs
			: [f] "r" (f)								
		// Clobbered register
			: "cc"									  
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

MyFloat MyFloat::operator-(const MyFloat& rhs) const{

	return *this;
}


float MyFloat::packFloat() const{
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

bool MyFloat::carryWouldHappen(unsigned int a, unsigned int b){
	bool carry = false;

	return carry;
}//carryWouldHappen
