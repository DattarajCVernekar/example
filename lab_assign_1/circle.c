#include<stdio.h>
#include<graphics.h>
#include<math.h>
 void DrawPoints(int xc,int yc, int a, int b)
            {
                    putpixel(xc+a, yc+b, 1);
                    putpixel(xc-a, yc+b, 1);
                    putpixel(xc-a, yc-b, 1);
                    putpixel(xc+a, yc-b, 1);
                    putpixel(xc+b, yc+a, 1);
                    putpixel(xc-b, yc+a, 1);
                    putpixel(xc-b, yc-a, 1);
                    putpixel(xc+b, yc-a, 1);
          }


 void CirclePolar(int xc,int yc, int R)
            {
            int x=R,y=0;
            double theta=0,dtheta=1.0/R;
            DrawPoints(xc,yc,x,y );
            while(x>y)
            {
            theta+=dtheta;
            x=round(R*cos(theta));
            y=round(R*sin(theta));
            DrawPoints(xc,yc,x,y);
            }
            }
 








int main()
{
   int gd = DETECT, gm,x,y,radius;
    printf("\ncentre->");
   scanf("%d%d",&x,&y);
   printf("\nradius->\t");
   scanf("%d",&radius);
   initgraph(&gd, &gm, "");
 
   
   CirclePolar(x, y,radius);
   getch();
   closegraph();
   return 0;
}

