library(InterMineR)

# Begin by initialising against an InterMine - in this case HumanMine
im <- initInterMine(mine=listMines()["HumanMine"], "j1q44e90S1Q4i6RekaB8")

# Fetch a public Gene list from HumanMine
data("PL_DiabetesGenes")

# preview the data in the list we've just loaded (show me its 'head')
head(PL_DiabetesGenes)

# Create a new query
expressedPancreas = newQuery(
  #here we're choosingwhich columns of data we'd like to see
  view = c("Gene.primaryIdentifier",
             "Gene.symbol",
             "Gene.proteinAtlasExpression.cellType",
             "Gene.proteinAtlasExpression.level",
             "Gene.proteinAtlasExpression.tissue.name"
  ),
  # set the logic for constraints (see the function for this to make sense)
  constraintLogic = "A and (B or C) and D"
)

# If we ran the query above, it'd show us *all* genes and their expression. 
# Let's narrow it down a little by constraining it to genes that are of interest
pancreasConstraint = setConstraints(
  paths = c("Gene", "Gene.proteinAtlasExpression.level", "Gene.proteinAtlasExpression.level", "Gene.proteinAtlasExpression.tissue.name"),
  operators = c("IN", rep("=", 2), "="),
  # each constraint is automatically given a code, allowing us to manipulate the 
  # logic for the constraint. 
  # Below, the constraints are set to codes A, B, C, D in order, 
  #  e.g. Code A: "Gene" should be "IN" the list named "PL_DiabetesGenes"
  #       Code B: "Gene.proteinAtlasExpression.level" should be equal to "Medium"
  #       Code C: "Gene.proteinAtlasExpression.level" should be equal to "High"
  #       Code D: "Gene.proteinAtlasExpression.tissue.name" should be equal to Pancreas"
  # 
  # Now, you might be thinking "how can the expression level be equal to both Medium AND High?"
  # and the answer is - it can't, but take a quick look at the constraintLogic we set earlier - 
  # (B or C) makes it clear that we want one or the other (but not, for instance, Low) 
  values = list("PL_DiabetesGenes", "Medium", "High", "Pancreas")
)

# Add the constraint to our expressed pancreas query (previously we just _defined_ the constraint)
expressedPancreas$where <- pancreasConstraint


# Now we have the query set up the way we want, let's actually *run* the query! 
query_results <-  runQuery(im = im, qry = expressedPancreas)

# Show me the first few results please! 
head(query_results) 

