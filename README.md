TITLE
--------------------
Symmetry-based Graph fourier transforms: are they optimal for image compression?


BRIEF DESCRIPTION OF THE PROJECT
--------------------
Traditional block-based transforms are based on applying a single transform to all blocks.~As an alternative,
better performance in image and video processing and representation can be achieved by choosing one among a discrete set of transforms for each block.
As an example, our recently proposed set of multiple transforms called Symmetry-Based Graph Fourier Transforms (SBGFTs) have shown good performance in terms of energy compaction,
improving HEVC intra coding performance when used to replace the Discrete Cosine Transform (DCT).
This paper further explores the performance of the SBGFTs in a multiple transforms, non-linear approximation perspective,
by comparing them with two alternative sets of orthogonal transforms, namely, the Karhunen-Loève Transform (KLT) and the Sparse Orthonormal Transform (SOT).
Experimental results confirm that SBGFTs achieve superior representation ability in this context as well,
suggesting that they could assume a central role in image compression.


USAGE
--------------------
Folders
--------------------
Folders Centroids and CentroidsHD collect the files .mat containing the centroids associated to the clusters calculated on the SD and HD datasets, respectively. 

The SD and HD clusters are located in the folders Clusters and ClustersHD, while their corresponding covariance matrices are in CovMat and CovMatHD.

Folder In includes the eigenvectors of the SBGFTs, KLTs and SOTs in their corresponding files .mat.

Note that the KLTs can be re-generated running the script generateKLT.m (see below), as well as the SOTs with the code located in the folder generateSOT.

Files
--------------------
main_exp.m performs the comparison between SBGFTs, KLTs and SOTs.

main_exp_x.m calculates the performance of the SBGFTs set with cardinality x. You can set the internal variable 'numb' to x, with x in [1,40].

main_exp_cardinality_reduction.m calculates the histogram of the SBGFTs. The resulting graph indices rank can be found in Indices.mat.

generateKLT.m generates the KLTs associated to the covariance matrices.

The clustering process is performed in Python by the function sklearn.cluster.KMeans().

## Citation

If you use this code in your work, please consider citing the following paper:

```
@INPROCEEDINGS{9506636,
  author={Gnutti, Alessandro and Guerrini, Fabrizio and Leonardi, Riccardo and Ortega, Antonio},
  booktitle={2021 IEEE International Conference on Image Processing (ICIP)}, 
  title={Symmetry-Based Graph Fourier Transforms: Are They Optimal For Image Compression?}, 
  year={2021},
  volume={},
  number={},
  pages={1594-1598},
  keywords={Image coding;Fourier transforms;Conferences;Clustering algorithms;Transforms;Approximation algorithms;Compaction;Graph Fourier Transforms;symmetric graphs;multiple transforms coding;image non-linear approximation},
  doi={10.1109/ICIP42928.2021.9506636}}
```

SUPPORT
--------------------
For any help request, please send an email to: alessandro.gnutti@unibs.it
