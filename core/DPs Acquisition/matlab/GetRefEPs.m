function [c,s,e] =  GetRefEPs(Ref,Nrep,temperature,f)
eps0 = 8.854187817*1e-12; %dielectric constant in space

Ref_EPs = cell(1,length(Ref.id));
eps = cell(1,length(Ref.id));
sgm = cell(1,length(Ref.id));
if length(Ref.conc)<length(Ref.id)
    conc = 100*ones(1,length(Ref.id));
    conc(Ref.id==4) = c2m(Ref.conc);
else
    conc = Ref.conc;
    conc(Ref.id==4) = c2m(Ref.conc(Ref.id==4));
end


    for k = 1:length(Ref.id)
        try
            Ref_EPs{k} = ReferenceLiquids(lookuptable(Ref.id(k)),temperature(k),conc(k),f);
            eps{k} = real(Ref_EPs{k});
            sgm{k} = -2*pi*f*eps0.*imag(Ref_EPs{k});
        catch
            if Ref.id(k)~=1 && Ref.id(k)~=2
                error('Opps: Specified Ref materail is not include in our Std. table');
            end
        end
    end
    if find(Ref.id==1)
        Ref_EPs{Ref.id==1} = 1;
        eps{Ref.id==1} = 1;
        sgm{Ref.id==1} = 0;
    end
    if find(Ref.id==2)
        Ref_EPs{Ref.id==2} = 0;
        eps{Ref.id==2} = 0;
        sgm{Ref.id==2} = 0;
    end
    x.complex = Ref_EPs;
    x.eps = eps;
    x.sgm = sgm;
    [c,s,e] = GetSpecifiedEPs(x,Nrep);
end

function y = lookuptable(x)
    Ref_name_table = {'open', 'short', 'water', 'NaCl', ...
                'Propan_1_ol', 'Ethanol', 'Methanol', 'Butan_1_ol', ...
                'Ethanediol', 'Dimethyl', 'sulphoxide', 'Propan_2_ol',...
               'Tissue','Artery','Brain_grey_matter','Brain_white_matter','Cartilage','Cerebellum','Cerebrospinal_fluid','Connective_tissue','Ear_cartilage','Ear_skin','Eye_vitreous_humor','Eye_lens','Fat','Hippocampus','Hypophysis','Hypothalamus','Intervertebral_disc','Larynx','Mandible','Marrow_red','Midbrain','Muscle','Bone','mucosa','Nerve','Pharynx','Skin','Skull','Spinal_cord','SAT','Teeth','Tendon_Ligament','Thalamus','Tongue','Vein','Vertebrae','Pineal_body','Pons','Medulla_oblongata','cornea','Eye_Sclera','Commissura_anterior','Commissura_posterior','Bronchi','Bronchi_lumen','Bladder','Diaphragm','Esophagus','Esophagus_lumen','Heart_lumen','Heart_muscle','Kidney_cortex','Adrenal_gland','Gallbladder','Kidney_medulla','Large_intestine','Large_intestine_lumen','Liver','Lung','Ovary','Pancreas','Small_intestine','Small_intestine_lumen','Spleen','Stomach','Stomach_lumen','Thymus','Thyroid_gland','Trachea','Trachea_lumen','Ureter_Urethra','Uterus','Vagina','Meniscus','Patella'};
     y = Ref_name_table{x};
end

function m = c2m(c,name)

if nargin<2
    name = 'NaCl';
end
switch name
    case 'NaCl'
        m = (c/100*1000/58.5); %58.8g/mol for NaCl
    otherwise
        warning('Specified material cannot be converted');
end
end

function [c,s,e] = GetSpecifiedEPs(x,Nrep)

EPs_in = x.complex;
s_in = x.sgm;
e_in = x.eps;
for k = 1:length(EPs_in)
   f(k) = length(EPs_in{k});
end
p = f;
p(p==1)=[];
if ~isempty(find((p(2:end)-p(1:end-1))~=0))
    warning('the length of EPs not uniform')
end
y = find(f==1);
for k = 1:length(y)
    EPs_in{k} = repmat(EPs_in{k},max(f),1);
    s_in{k} = repmat(s_in{k},max(f),1);
    e_in{k} = repmat(e_in{k},max(f),1);
end
 
c = repmat(EPs_in{1},1,Nrep(1));
s = repmat(s_in{1},1,Nrep(1));
e = repmat(e_in{1},1,Nrep(1));
for k = 2:length(Nrep)
    c = [c,repmat(EPs_in{k},1,Nrep(k))];
    s = [s,repmat(s_in{k},1,Nrep(k))];
    e = [e,repmat(e_in{k},1,Nrep(k))];
end

end