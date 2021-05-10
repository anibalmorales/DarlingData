CREATE OR ALTER FUNCTION NumberOfPayments_Inline
(
    @Rate float,
    @Years float,
    @PreviousValue float,
    @FutureValue float,
    @Payments float,
    @PaymentsPerYear float,
    @Type int
)
RETURNS table
AS
RETURN
    
    SELECT
        NumPayments =
            CONVERT
            (
                float,              
                CASE 
                     WHEN (@Type = 0 
                             OR @Type IS NULL)
                     THEN LOG(POWER(1 + @Rate / @PaymentsPerYear, @PaymentsPerYear))
                              / LOG((@Payments * (POWER(1 + @Rate / @PaymentsPerYear, @Years * @PaymentsPerYear) - 1))
                                  / (@FutureValue - @PreviousValue * POWER(1 + @Rate / @PaymentsPerYear, @Years * @PaymentsPerYear)) + 1)
                     WHEN @Type = 1
                     THEN LOG(POWER(1 + @Rate / @PaymentsPerYear, @PaymentsPerYear))
                              / -LOG(1 - (@Payments * (POWER(1 + @Rate / @PaymentsPerYear, @Years * @PaymentsPerYear) - 1))
                                  / (@FutureValue - @PreviousValue * POWER(1 + @Rate / @PaymentsPerYear, @Years * @PaymentsPerYear)))
                END
            );
GO