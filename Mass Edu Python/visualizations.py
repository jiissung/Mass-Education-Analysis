import pandas as pd
import matplotlib.pyplot as plt
from scipy.stats import pearsonr

# Loads dataframes
df = pd.read_csv('higherthanavg salary.csv')
df2 = pd.read_csv('hightplowmcas.csv')


# Changes dataframes into lists
teacher_salary = df['district_name'].tolist()
banana = df2['district_name'].tolist()
tp = df2["teacher_proficiency"].tolist()
mcas = df2["avg_mcas_score"].tolist()


count = 0
for district in banana:
    if district in teacher_salary:
        count += 1
print("Number of schools that scored lower than average\n MCAS scores with lower than average teacher salaries:")
print(count, "out of", len(banana))



plt.title("Teacher Proficiency vs Average MCAS Results (10th Grade")
plt.xlabel("% Population of Proficient Teachers")
plt.ylabel("Average MCAS Score")
plt.scatter(tp, mcas)
plt.show()




df3 = pd.read_csv("economic.csv")


math_df = (df3[df3["subject"] == "MATH"])
sci_df = (df3[df3["subject"] == "SCI"])
ela_df = (df3[df3["subject"] == "ELA"])

plt.title("% Economically Disadvantaged vs MCAS Math Score (10th Grade)")
plt.xlabel("% Economically Disadvantaged")
plt.ylabel("Average Math MCAS Score")
plt.scatter(math_df["percent_economically_disadvantaged"], math_df["avg_scaled_score1"])
plt.show()
corr, p_value = pearsonr(math_df["percent_economically_disadvantaged"], math_df["avg_scaled_score1"])
print("Math Correlation Coefficient:")
print(corr, "\n")


plt.title("% Economically Disadvantaged vs Science Score (10th Grade)")
plt.xlabel("% Economically Disadvantaged")
plt.ylabel("Average Science MCAS Score")
plt.scatter(sci_df["percent_economically_disadvantaged"], sci_df["avg_scaled_score1"], color = "red")
plt.show()
corr2, p_value2 = pearsonr(sci_df["percent_economically_disadvantaged"], sci_df["avg_scaled_score1"])
print("Science Correlation Coefficient:")
print(corr2, "\n")

plt.title("% Economically Disadvantaged vs MCAS ELA Score (10th Grade)")
plt.xlabel("% Economically Disadvantaged")
plt.ylabel("Average ELA MCAS Score")
plt.scatter(ela_df["percent_economically_disadvantaged"], ela_df["avg_scaled_score1"], color = "orange")
plt.show()
corr3, p_value3 = pearsonr(ela_df["percent_economically_disadvantaged"], ela_df["avg_scaled_score1"])
print("ELA Correlation Coefficient")
print(corr3)
