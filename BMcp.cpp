# include <cmath>
# include <cstdlib>
# include <cstring>
# include <ctime>
# include <fstream>
# include <iomanip>
# include <iostream>
# include <stdlib.h>
# include <stdio.h>
# include <random>
# include <chrono>

using namespace std;

float *simpBm(float *bbmm, float *dx, const int N)
{
  const int ones[] = {-1,1};
  int m = 0;

  for(int j = 0; j < N; j++)
  {
    m = rand() % 2;
    int Z = ones[m];
    dx[j] += (Z/2.0);
    bbmm[j+1] += bbmm[j] + dx[j];
  }
  return bbmm;
}

float *simpWP(float *wwpp, float *dw, const int N)
{
  const int T = 1;
  std::default_random_engine generator;
  std::normal_distribution<double> distribution(0.0,1.0);
  float dt = T/float(N);

  for(int i = 1; i < N; i++)
  {
    double rinr = distribution(generator);
    dw[i] = sqrt(dt)*rinr;
    wwpp[i] = wwpp[i-1] + dw[i];
  }
  return wwpp;
}

void io_fun(std::string file, float *x, const int N)
{
  std::ofstream myfile_tsN;
  myfile_tsN.open(file);
  for(int i = 0; i< N; i++)
  {
    myfile_tsN << x[i] << std::endl;
  }
  myfile_tsN.close();
}

int main()
{
  const int T = 1;
  //const int N = 256;
  //const int N = 768;
  //const int N = 1600;
  //const int N = 3200;
  const int N = 500000;
  float BMa[N] = {0.0};
  float dx[N]  = {0.0};
  float dw[N]  = {0.0};
  float WPa[N] = {0.0};

  std::string f2;
  std::string f3;
  f2 = "bbm.dat";
  f3 = "wwp.dat";


  std::chrono::steady_clock::time_point star = std::chrono::steady_clock::now();
  simpBm(BMa,dx,N);
  std::chrono::steady_clock::time_point en = chrono::steady_clock::now();

  std::chrono::steady_clock::time_point start = std::chrono::steady_clock::now();
  simpWP(WPa,dw,N);
  std::chrono::steady_clock::time_point end = chrono::steady_clock::now();

  cout << "Serial random walk time in microseconds: "
       << chrono::duration_cast<chrono::milliseconds>(en - star).count()
       << " microseconds" << endl;

  cout << "Serial Weiner Process time in microseconds: "
       << chrono::duration_cast<chrono::milliseconds>(end - start).count()
       << " microseconds" << endl;
  io_fun(f2,BMa,N);
  io_fun(f3,WPa,N);

}
