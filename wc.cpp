/*
 * flag=0の間はカウントをしないので適宜追加、変更してください
 * 特にbegin{figure}[]の位置指定は注意。
 * -v を付けて実行することで何がカウントされているか出力されます。
 */

#include <iostream>
#include <string>
#include <sstream>
#include <map>
#include <cstdio>
#include <cstring>

using namespace std;

int main(int argc, char *argv[]){
    string str,tmp;
    bool flag = false, v = false;
    int cnt = 0;
    map<string,int> dic;

    for(int i=0;i<argc;i++){
        if(strcmp(argv[i],"-v") == 0){
            v = true;
        }
    }

    while(getline(cin,str)){
        if(str == "\\chapter{Introduction}") flag = true;
        if(str == "\\chapter*{References}") flag = false;
        if(str == "\\begin{eqnarray}") flag = false;
        if(str == "\\end{eqnarray}") flag = true;
        if(str == "\\begin{equation}") flag = false;
        if(str == "\\end{equation}") flag = true;
        if(str == "\\begin{table}[H]") flag = false;
        if(str == "\\end{table}") flag = true;
        if(str == "\\begin{enumerate}") flag = false;
        if(str == "\\end{enumerate}") flag = true;
        if(str == "\\begin{quote}") flag = false;
        if(str == "\\end{quote}") flag = true;
        if(str == "\\begin{figure}[H]") flag = false;
        if(str == "\\end{figure}") flag = true;
        if(str == "\\[") flag = false;
        if(str == "\\]") flag = true;
        if(str == "\\begin{thebibliography}[99]") flag = false;
        if(str == "\\end{thebibliography}[99]") flag = true;

        if(!flag || str[0] == '%' || str[0] == '\\') continue;
        istringstream iss(str);
        while(iss >> tmp){
            if(tmp[0] == '$'){
                flag = false;
            }
            
            if(flag && tmp[0] != '\\' && tmp[0] != '{' && tmp[0] != '('){
                dic[tmp]++;
                cnt++;
            }

            if(tmp[tmp.size()-1] == '$' || tmp[tmp.size()-2] == '$'){
                flag = true;
            }
        }
    }
    cout << cnt << endl;
    if(v){
        for(map<string,int>::iterator it=dic.begin();it!=dic.end();++it){
            cout << (*it).first << " :" << (*it).second << endl;
        }
    }
}
