#include <iostream>
#include <cstdlib>

using namespace std;

int **matmult (int **mat_a, int mat_a_rows, int mat_a_cols, int **mat_b, int mat_b_rows, int mat_b_cols) {
	int mat_a_size = mat_a_rows * mat_a_cols;
	int mat_b_size = mat_b_rows * mat_b_cols;
	int **mat_c = (int **) malloc(mat_a_rows * sizeof(int *));

	for(int i = 0; i < mat_a_rows; i++) mat_c[i] = (int *) malloc(mat_b_cols * sizeof(int));

	for(int i = 0; i < mat_a_rows; i++) {
		for(int k = 0; k < mat_a_cols; k++) {
			int sum = 0;

			for(int n = 0; n < mat_a_rows; n++) {
				sum = mat_a[i][n] * mat_b[n][i];
			}

			//cout << i << " " << k << " : "<< sum << endl;
			
			mat_c[i][k] = sum;
		}
	}

	return mat_c;
}

int main() {
	int rows = 2;
	int cols = 2;
	int **mat_a, **mat_b, **mat_c;

	mat_a = (int **) malloc(cols * sizeof(int *));
	mat_b = (int **) malloc(cols * sizeof(int *));

	for(int i = 0; i < rows; i++) {
		mat_a[i] = (int *) malloc(cols * sizeof(int));
		mat_b[i] = (int *) malloc(cols * sizeof(int));
	}

	for(int i = 0; i < rows; i++) {
		for(int n = 0; n < cols; n++) {
			mat_a[i][n] = i + n;
			mat_b[i][n] = i;

			cout << mat_b[i][n];
		}

		cout << endl;
	}

	mat_c = matmult(mat_a, rows, cols, mat_b, rows, cols);

	for(int i = 0; i < rows; i++) {
		for(int n = 0; n < cols; n++) {
			//cout << mat_c[i][n] << endl;
		}
	}


	return 0;
}
