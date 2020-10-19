#include<stdio.h>



int main()
{
   int i;
int choice;

do{
printf("\n\n ###### Welcome to Election/Voting 2019 #####");
printf("\n\n 1. Cast the Vote");
printf("\n 2. Find Vote Count");
printf("\n 3. Find leading Candidate");
printf("\n 0. Exit");

printf("\n\n Please enter your choice : ");
scanf("%d", &choice);
int a=1;
switch(choice)
{
case 1: castVote(a);break;
case 2: votesCount(a);break;
case 3: getLeadingCandidate(a);break;
default: printf("\n Error: Invalid Choice");
}
}while(choice!=0);

//hold the screen
getchar();

return 0;
}
