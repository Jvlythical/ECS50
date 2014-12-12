#include <iostream>
#include <cmath>
#include <bitset>
#include <algorithm>

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

MyFloat MyFloat::operator-(const MyFloat& rhs) const{
	MyFloat diff(rhs);
	if(diff.sign == 1)diff.sign = 0;
	else diff.sign = 1;

	return operator+(diff);
}

MyFloat MyFloat::operator+(const MyFloat& rhs) const{

	MyFloat sum(rhs);

	unsigned int mant_1 = mantissa + pow(2, 23), mant_2 = sum.mantissa + pow(2, 23);
	int rexp_1 = exponent - 127, rexp_2 = sum.exponent - 127;
	int bias = max(rexp_1, rexp_2);
	int i = 0, rexp_diff = abs((int) rexp_2 - (int) rexp_1);

	//cout << rexp_1 << " " << rexp_2 << endl;
	//cout << bitset<32>(mant_1).to_string() << " " << bitset<32>(mant_2).to_string() << endl;
	
	if(exponent == 0) return sum;
	if(sum.exponent == 0) return *this;
	if(mant_1 == mant_2 && sum.sign != sign && !rexp_diff) {
		sum.exponent = 0;
		sum.mantissa = 0;
		sum.sign = 0;

		return sum;
	}

	if(rexp_diff < 8) {
		if(rexp_1 > rexp_2) mant_1 = mant_1 << rexp_diff;
		else mant_2 = mant_2 << rexp_diff;
	}
	else {
		if(rexp_1 < rexp_2) mant_1 = mant_1 >> rexp_diff;
		else mant_2 = mant_2 >> rexp_diff;
	}
	
	//cout << rexp_diff << endl;	
	//cout << bitset<32>(mant_1).to_string() << " " << bitset<32>(mant_2).to_string() << endl;
		
	if(sign == sum.sign) {
		if(carryWouldHappen(mant_1, mant_2)) {
			// Stuff
		}

		sum.mantissa = mant_1 + mant_2;
		for(i = 31; i >= 0; i--) if(max(mant_1, mant_2) & (int) pow(2, i)) break;	
		if(sum.mantissa & (int) pow(2, i + 1)) ++bias;
	}
	else {
		if(carryWouldHappen(mant_1, mant_2)) {
			// Stuff
		}

		sum.mantissa = max(mant_1, mant_2) - min(mant_1, mant_2);
		if (rexp_2 < rexp_1) sum.sign = sign;
		if(rexp_diff == 0 && mant_2 < mant_1) sum.sign = sign; 
		for(i = 31; i >= 0; i--) if(max(mant_1, mant_2) & (int) pow(2, i)) break;	
		if((sum.mantissa & (int) pow(2, i)) == 0) --bias;
	}

	for(i = 31; i >= 0; i--) if(sum.mantissa & (int) pow(2, i)) break; 
	sum.mantissa = (sum.mantissa - (int) pow(2, i)) >> (i - 23) ; 
	sum.exponent = bias + 127;

	//cout << "Exponent: " << sum.exponent << endl;
	//cout << bitset<32>(sum.mantissa).to_string() << endl;

	return sum;
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


