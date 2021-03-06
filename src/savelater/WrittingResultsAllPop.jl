#_______________________________________________________________________________
# Writting results

    # requirements fulfillement
RequirSheet = getSheet( CPworkbook, "Requirements" )
if RequirSheet.ptr === Ptr{Void}( 0 )
    RequirSheet = createSheet( CPworkbook, "Requirements" )
end

rowIdx = 0
Row = createRow(RequirSheet, rowIdx)
rowIdx += 1

cellIdx = 1
for i in 1:length(MPObjectives)
    obj = ""
    for j in 1:length(MPObjectives[i].Objectives)
        obj = obj * MPObjectives[i].Objectives[j]
    end
    Cell=createCell(Row, cellIdx); setCellValue(Cell, obj)
    cellIdx += 1
end
for i in 1:NBYears
    Row = createRow(RequirSheet, rowIdx)
    rowIdx += 1
    cellIdx = 0
    Cell=createCell(Row, cellIdx); setCellValue(Cell, i)
    cellIdx += 1
    for j in 1:length(MPObjectives)
        Cell=createCell(Row, cellIdx); setCellValue(Cell, round(Int, RequirementFulfillment[i, j]))
        cellIdx += 1
    end
end


    # Initial manpower distribution
InitDistSheet = getSheet( CPworkbook, "Initial distribution" )
if InitDistSheet.ptr === Ptr{Void}( 0 )
    InitDistSheet = createSheet( CPworkbook, "Initial distribution" )
end

rowIdx = 0
Row = createRow(InitDistSheet, rowIdx)
rowIdx += 1

cellIdx = 2
#for i in 1:length(GuyCareerPaths)
#    Cell=createCell(Row, cellIdx); setCellValue(Cell, i)
#    cellIdx += 1
#end

index = 1
for i in 1:length(InitManpower)
    Row = createRow(InitDistSheet, rowIdx)
    rowIdx += 1
    cellIdx = 0
    Cell=createCell(Row, cellIdx); setCellValue(Cell, InitManpower[i].Academiclvl)
    cellIdx += 1
    Cell=createCell(Row, cellIdx); setCellValue(Cell, InitManpower[i].Seniority)
    cellIdx += 1
    for j in 1:length(GuyCareerPaths)
        if j in InitMPPartCP[i]
            if sol.sol[index] != 0
                Cell=createCell(Row, cellIdx); setCellValue(Cell, j); cellIdx += 1
                Cell=createCell(Row, cellIdx); setCellValue(Cell, sol.sol[index]); cellIdx += 1
            end
            index += 1
        end
#        Cell=createCell(Row, cellIdx);

#        if j in InitMPPartCP[i]
#            setCellValue(Cell, sol.sol[index])
#            index += 1
#        else
#            setCellValue(Cell, 0)
    end
end

    # Annual Recruitment
RecruitmentSheet = getSheet( CPworkbook, "Perforemed Recruitment" )
if RecruitmentSheet.ptr === Ptr{Void}( 0 )
    RecruitmentSheet = createSheet( CPworkbook, "Perforemed Recruitment" )
end

rowIdx = 0
#Row = createRow(RecruitmentSheet, rowIdx)
rowIdx += 1

#cellIdx = 1
#for i in 1:length(GuyCareerPaths)
#    Cell=createCell(Row, cellIdx); setCellValue(Cell, i)
#    cellIdx += 1
#end
#Cell=createCell(Row, cellIdx); setCellValue(Cell, "sum")

for i in 1:NBYears
    sum = 0
    Row = createRow(RecruitmentSheet, rowIdx)
    rowIdx += 1
    cellIdx = 0
    Cell=createCell(Row, cellIdx); setCellValue(Cell, i)
    cellIdx += 2
    for j in 1:length(GuyCareerPaths)
        if sol.sol[InitMPDivisionNb + (i - 1)*length(GuyCareerPaths) + j] != 0
            sum += sol.sol[InitMPDivisionNb + (i - 1)*length(GuyCareerPaths) + j]
            Cell=createCell(Row, cellIdx); setCellValue(Cell, j)
            cellIdx += 1
            Cell=createCell(Row, cellIdx); setCellValue(Cell, sol.sol[InitMPDivisionNb + (i - 1)*length(GuyCareerPaths) + j])
            cellIdx += 1
        end
    end
    Cell=createCell(Row, 1); setCellValue(Cell, sum)
    cellIdx += 1
end

    # rectuirment Variables

# rectuirmentVariables = getSheet( CPworkbook, "rectuirmentVariables" )
# if rectuirmentVariables.ptr === Ptr{Void}( 0 )
#     rectuirmentVariables = createSheet( CPworkbook, "rectuirmentVariables" )
# end

    # Deviation Variables

DeviationVariables = getSheet( CPworkbook, "DeviationVariables" )
if DeviationVariables.ptr === Ptr{Void}( 0 )
    DeviationVariables = createSheet( CPworkbook, "DeviationVariables" )
end

rowIdx = 0
Row = createRow(DeviationVariables, rowIdx)
rowIdx += 1

cellIdx = 0
Cell=createCell(Row, cellIdx); setCellValue(Cell, rowIdx)
cellIdx += 1
for i in 1:(length(GuyCareerPaths) * NBYears)

    Cell=createCell(Row, cellIdx); setCellValue(Cell, sol.sol[InitMPDivisionNb + i])
    cellIdx += 1
    if i%length(GuyCareerPaths) == 0
        Row = createRow(DeviationVariables, rowIdx)
        rowIdx += 1

        cellIdx = 0
        Cell=createCell(Row, cellIdx); setCellValue(Cell, rowIdx)
        cellIdx += 1
    end
end
        #Positive deviation
rowIdx = 0
Row = createRow(DeviationVariables, rowIdx)
rowIdx += 1

cellIdx = 0
Cell=createCell(Row, cellIdx); setCellValue(Cell, rowIdx)
cellIdx += 1
for i in 1:(length(MPObjectives) * NBYears)

    Cell=createCell(Row, cellIdx); setCellValue(Cell, sol.sol[InitMPDivisionNb + AnnualRecDivNb + i])
    cellIdx += 1
    if i%length(MPObjectives) == 0
        Row = createRow(DeviationVariables, rowIdx)
        rowIdx += 1

        cellIdx = 0
        Cell=createCell(Row, cellIdx); setCellValue(Cell, rowIdx)
        cellIdx += 1
    end
end
        # Negative deviation
rowIdx += 2
Row = createRow(DeviationVariables, rowIdx)
rowIdx += 1

cellIdx = 0
Cell=createCell(Row, cellIdx); setCellValue(Cell, rowIdx)
cellIdx += 1
for i in 1:(length(MPObjectives) * NBYears)

    Cell=createCell(Row, cellIdx); setCellValue(Cell, sol.sol[InitMPDivisionNb + AnnualRecDivNb + (length(MPObjectives) * NBYears) + i])
    cellIdx += 1
    if i%length(MPObjectives) == 0
        Row = createRow(DeviationVariables, rowIdx)
        rowIdx += 1

        cellIdx = 0
        Cell=createCell(Row, cellIdx); setCellValue(Cell, rowIdx)
        cellIdx += 1
    end
end

#try rm(joinpath( dirname( Base.source_path() ), "..", "..", "..", "GuyCPResultsAll.xlsx" )) end
write(joinpath( dirname( Base.source_path() ), "..", "..", "..", "GuyCPResultsAllPop.xlsx" ), CPworkbook)
