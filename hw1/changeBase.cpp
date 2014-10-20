#include <iostream>
#include <string>
#include <vector>

using namespace std;

/* ------------------------------------------------
 *	Changes a base 10 number to a specified base
 * ------------------------------------------------
 */

string change_base(int new_base, int num) {
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

	for(int i = tmp.length() - 1; i >= 0; i--) {
		new_num = new_num + tmp[i];
	}

	return new_num;
}

/* --------------------------------
 *	Converts a number to base 10
 * --------------------------------
 */

int change_base_10(int base, string num) {
	int base_10_num = 0;
	
	for(int i = num.length() - 1; i >= 0; i--) {
		int margin, exp = 1;

		for(int n = 0; n < num.length() - 1 - i; n++) exp = exp * base; 
		if(num[i] <= '9' && num[i] >= '0') margin = num[i] - '0';
		else if (num[i] <= 'z' && num[i] >= 'a') margin = num[i] - 'a' + 10;
		else margin = num[i] - 'A' + 10;

		base_10_num = base_10_num + margin * exp;  	
	}

	return base_10_num;
}

int main() {
	int base_index = 0, num_index = 1, new_base_index = 2;
	vector<int> inputs;
	string prompts[] = {
		"Please enter the number's base: ",
		"Please enter the number: ",
		"Please enter the new base: "
	};
	string num;

	for(int i = 0; i < sizeof(prompts) / sizeof(string); i++) {
		string tmp_str;
		int base;

		cout << prompts[i];
		cin >> tmp_str;
		
		if(i == num_index) {
			base = inputs[base_index];
			num = tmp_str;
		}
		else base = 10;
			
		inputs.push_back(change_base_10(base, tmp_str));
	}

	cout << num << " in base " << inputs[new_base_index] << " is " 
	<< change_base(inputs[new_base_index], inputs[num_index]) << endl;

	return 0;
}
