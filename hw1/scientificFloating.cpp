#include <iostream>
#include <string>

using namespace std;

string change_base(int new_base, unsigned int num) {
	int rmd_num;
	string new_num, rmd_str, tmp;

	do {
		rmd_num = num % new_base;
		if(rmd_num < 10) rmd_str = '0' + rmd_num;
		else rmd_str = 'A' + (rmd_num - 10);

		tmp = tmp + rmd_str;
		num = num / new_base;
	}
	while(num != 0);
	for(int i = tmp.length() - 1; i >= 0; i--) new_num = new_num + tmp[i];
	
	return new_num;
}

int change_base_10(int base, string num) {
	int base_10_num = 0;

	for(int i = num.length() - 1; i >= 0; i--) {
		int margin, exp = 1;

		for(unsigned int n = 0; n < num.length() - 1 - i; n++) exp = exp * base; 
		if(num[i] <= '9' && num[i] >= '0') margin = num[i] - '0';
		else if (num[i] <= 'z' && num[i] >= 'a') margin = num[i] - 'a' + 10;
		else margin = num[i] - 'A' + 10;

		base_10_num = base_10_num + margin * exp;  	
	}

	return base_10_num;
}

string binary_to_scientific(string bin) {
	int is_neg = 0;
	string num = "";

	while(bin.length() != 32) bin = "0" + bin;
	if(bin[0] == '1') is_neg = 1;

	for(int i = 9; i < 32; i++) {
		num = num + bin[i];
	}

	num = num.substr(0, num.find_last_of('1') + 1);
	num = num + "E" + change_base(10, change_base_10(2, bin.substr(1, 8)) - 127);

	if(is_neg) num = "-1." + num;
	else num = "1." + num;

	return num;
}

int main(int argc, char *argv[]) {
	float f_num;
	unsigned int i_num;
	
	cout << "Please enter a float: ";
	cin >> f_num;

	i_num = *((unsigned int *) &f_num);

	if(i_num == 0) cout << "0E0" << endl;
	else cout << binary_to_scientific(change_base(2, i_num)) << endl;

	return 0;
}
