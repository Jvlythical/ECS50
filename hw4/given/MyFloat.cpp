#include "MyFloat.h"

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



void MyFloat::unpackFloat(float f) {

}//unpackFloat

float MyFloat::packFloat() const{
  //returns the floating point number represented by this
  float f = 0;
  
  return f;
}//packFloat
//

bool MyFloat::carryWouldHappen(unsigned int a, unsigned int b){
  bool carry = false;
 
  return carry;
}//carryWouldHappen


