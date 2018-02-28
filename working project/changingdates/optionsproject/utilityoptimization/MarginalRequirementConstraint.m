classdef MarginalRequirementConstraint < UtilityMaximizationConstraint
    %utility=-2.2558615
    properties
        spot
    end
    
    methods 
        
        function c = MarginalRequirementConstraint(spot)
            c.spot=spot;
        end
        
        function applyConstraint( c, utilityMaximizationSolver, geometricProblem ) 
        % Apply the constraint to the separable problem
            %Implement
            %nj<=0---------------------------------------------------------
            s = utilityMaximizationSolver;
            A=horzcat(zeros(s.nq,s.nq+1),eye(s.nq,s.nq));
            b=zeros(s.nq,1);
            geometricProblem.addLinearUpperBound(A,b,'quantity constraint short');
            %--------------------------------------------------------------
            %Implement nj<=xj(t-1)+delxj(t)
            currentPortfolio=s.p.currentPosition;
            for idx=2:length(s.p.instruments)
                aaa=s.p.instruments(idx);
                assert(length(aaa)==1);
                name=aaa{1}.print;
                %name=s.p.instruments(idx).print;
                idxPrePort=find(strcmp(keys(currentPortfolio.map),name));
                if idxPrePort>=0
                    tempp=values(currentPortfolio.map);
                    xtminus1=tempp{idxPrePort}.quantity;
                else
                    xtminus1=0;
                end
                xtminus1;
                    indices = find(s.indexToInstrument==idx);
                    for idxx=indices
                        short = s.indexToShort(idxx);
                        if short
                            temp=zeros(1,s.nq+1+s.nq);
                            temp(idxx)=1;
                            temp(s.nq+1+idxx)=1;
                            geometricProblem.addLinearUpperBound(temp,xtminus1,'quantity constraint short');
                            temp;
                            xtminus1;
                        else       
                            temp=zeros(1,s.nq+1+s.nq);
                            temp(idxx)=-1;
                            temp(s.nq+1+idxx)=1;
                            geometricProblem.addLinearUpperBound(temp,xtminus1,'quantity constraint long');
                            temp;
                            xtminus1;
                        end
                    end        
            end
            %--------------------------------------------------------------
            %Implement x0(t)>=Sum_{j in J\{0}} f^j(nj)+Sum_{j not in J(t) but in
            %J(t-1)} f^^j(xj(t-1)) ----------------------------------------
            temp=zeros(1,s.nq+1+s.nq);
            bbb=s.p.instruments;
            name=bbb{1}.print;
            assert(strcmp(name,'Bond'))
                idxPrePort=find(strcmp(keys(currentPortfolio.map),name));
                if idxPrePort>=0
                    tempp=values(currentPortfolio.map);
                    x0tminus1=tempp{idxPrePort}.quantity;
                else
                    x0tminus1=0;
                end
                x0tminus1;
            %marginal requirement of assets which become illiquid ---------
                key=keys(currentPortfolio.map);
                value=values(currentPortfolio.map);
                instruments=s.p.instruments;
                margin=0;
                for idx=1:length(key)
                    if not(strcmp(key{idx},'Bond'))
                        liquid=0;
                        for jj=1:length((instruments))
                            if strcmp(key{idx},instruments{jj}.print)
                                liquid=1;
                            end
                        end
                        if liquid==0
                            if value{idx}.quantity<0
                                value{idx}.instrument
                                margin=margin-max(value{idx}.instrument.marginal20(c.spot),value{idx}.instrument.marginal10(c.spot))*value{idx}.quantity;
                            end
                        end
                    end
                end
               margin    
            %--------------------------------------------------------------
            %b=[-x0tminus1];
            b=[-x0tminus1+margin];
            indices = find(s.indexToInstrument==1);
            indices = sort(indices);
            assert(length(indices)==2);
            for idxxx=indices
                if idxxx==1
                    temp(idxxx)=-1;
                else
                    temp(idxxx)=1;
                end
            end
            for idx=2:length(s.p.instruments)
                indices = find(s.indexToInstrument==idx);
                asset=s.p.instruments{idx};
                temp(s.nq+1+indices)=max(asset.marginal20(c.spot),asset.marginal10(c.spot) );
            end   
            temp;
            b;
            geometricProblem.addLinearLowerBound(temp,b,'margin main');
            %---------------------------------------------------------------------
            temp=zeros(1,s.nq+1+s.nq);
            temp(s.nq+1+1)=1;
            geometricProblem.addLinearLowerBound(temp,0,'margin main');
            temp=zeros(1,s.nq+1+s.nq);
            temp(s.nq+1+2)=1;
            geometricProblem.addLinearLowerBound(temp,0,'margin main');
            numberOfVariables=s.nq

            
            
            %y(t)=delx(t)+x(t-1)
%             
%             indices = find(s.indexToInstrument==c.instrumentIndex);
%             for i=indices
%                 short = s.indexToShort(i);
%                 if short
%                     temp=zeros(1,s.nq+1);
%                     temp(i)=1;
%                     geometricProblem.addLinearUpperBound(temp,-c.min,'quantity constraint short');
%                 else       
%                     temp=zeros(1,s.nq+1);
%                     temp(i)=1;
%                     geometricProblem.addLinearUpperBound(temp,c.max,'quantity constraint long');
%                 end
%             end
            
        end
        
        function c = rescale( c, scale)
            % Produce a rescaled constraint when all the associated prices
            % are multiplied by the given factor            
            factor = scale( c.instrumentIndex );
            c.min = c.min/factor;
            c.max = c.max/factor;
        end
        
    end
            
end



