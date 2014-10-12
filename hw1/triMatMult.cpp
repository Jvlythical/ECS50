#include <iostream>
#include <vector>
#include <iostream>
#include <fstream>
#include <sstream>
#include <string>

using namespace std;

int row_times_col(vector<int> row, vector<int> col, int size_n) {
	int sum = 0, count = 0, changed = 0;
	int col_end = col.size();
	int row_start = size_n - row.size();
	ostringstream convert;

	for(int i = 0; i < col_end; i++) {
		if(i < row_start) {
			count++;
			continue;
		}

		changed = 1;
		sum = sum + row[i - count] * col[i];
	}

	if(changed) return sum;
	else return 123456789;
}

vector<int> read_matx(char *file_name) {
	int tmp, i = 0;
	vector<int> matx;
	ifstream file(file_name);
	string line;
	
	if(file.is_open()) {
		while(getline(file, line)) {
			if(i == 0) {
				i++;
				continue;
			}

			istringstream buffer(line);
			buffer >> tmp;
			matx.push_back(tmp);
		}
		file.close();
	}

	return matx;
}

void print_matx(vector<int> matx) {
	for(int i = 0; i < matx.size(); i++) {
		cout << matx[i] << " ";
	}

	cout << endl;
}

/* ---------
 *	Main()
 * ---------
 */

int main(int argc, char *argv[]) {
	int row_start = 0, col_size = 0, count = 0;
	vector<int> matx_1, matx_2, matx_3, row, col, inc;
	string line;
	ifstream file(argv[1]);

	if(file.is_open()) {
		getline(file, line);
		istringstream buffer(line);
		buffer >> col_size;
	}

	for(int i = col_size - 1; i >= 1; i--) inc.push_back(i);
	matx_1 = read_matx(argv[1]);
	matx_2 = read_matx(argv[2]);

	for(int k = col_size - 1; k >= 0; k--) {
		
		/* ----------------
		 *	Get row data
		 * ----------------
		 */

		for(int i = 0; i <= k; i++) {
				row.push_back(matx_1[row_start + i]);

				if(i == k) row_start = row_start + i + 1;
		}

		/* -------------------
		 *	Get column data
		 * -------------------
		 */

		int col_start = 0;
		
		for(int i = 0; i < col_size; i++) {
			for(int n = 0; n <= i; n++) {
				if(n > 0) col_start = col_start + inc[n - 1];
				else col_start = i;
				col.push_back(matx_2[col_start]);
			}

			int ele = row_times_col(row, col, col_size);
			if(ele != 123456789) matx_3.push_back(ele);

			col.clear();
		}
		row.clear();
	}

	print_matx(matx_3);

	return 0;
}
