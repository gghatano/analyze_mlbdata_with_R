#!/usr/local/bin/python

import pandas as pd
import numpy as np
from ply import install_ply, X, sym_call
install_ply(pd)

data = pd.read_csv("salary_2013.csv", header=0, encoding='UTF-8')

teamYearSalary = (data 
    .ply_where(X.YEAR == 2013) 
    .groupby(['YEAR', 'TEAM']) 
    .ply_select(
      SALARY_ALL = X.SALARY.sum(),
      SALARY_MEAN = X.SALARY.mean()
      )
    )

print teamYearSalary
