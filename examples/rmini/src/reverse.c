void reverse(double *a, int *na, double *b)
{
    int i;
    for(i = 0; i < *na; i++)
    b[i] = a[*na - i - 1];
}

