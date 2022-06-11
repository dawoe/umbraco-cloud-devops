$cloudProjectFile = "$(solutionNamespace).Cloud\src\$(solutionNamespace).Web\$(solutionNamespace).Web.csproj"
$sourceProjectFile = "$(solutionNamespace).Temp\code\$(solutionNamespace).Web.csproj"

# Test if project file exists
if(-Not(Test-Path -Path $cloudProjectFile -PathType Leaf)) 
{
    Write-Error "Cloud Project file not found"
    exit(1);
}

# Test if project file exists
if(-Not(Test-Path -Path $sourceProjectFile -PathType Leaf)) 
{
    Write-Error "Source Project file not found"
    exit(1);
}

# load cloud project file xml
$cloudXml = New-Object System.Xml.XmlDocument
$cloudXml.Load($cloudProjectFile)

# load source project file xml
$sourceXml = New-Object System.Xml.XmlDocument
$sourceXml.Load($sourceProjectFile)

#check umbraco version
$cloudUmbracoVersion = Select-XML -xml $cloudXml -XPath '(//PackageReference[@Include="Umbraco.Cms"])[1]'
$sourceUmbracoVersion = Select-XML -xml $sourceXml -XPath '(//PackageReference[@Include="Umbraco.Cms"])[1]'

if(-not($cloudUmbracoVersion.Node.Attributes.GetNamedItem("Version").Value -eq 
    $sourceUmbracoVersion.Node.Attributes.GetNamedItem("Version").Value))
{
    Write-Error "Umbraco.Cms version is different. Possibly due to auto upgrade. Aborting release"
    exit(1)
}

#check umbraco forms
$cloudFormsVersion = Select-XML -xml $cloudXml -XPath '(//PackageReference[@Include="Umbraco.Forms"])[1]'
$sourceFormsVersion = Select-XML -xml $sourceXml -XPath '(//PackageReference[@Include="Umbraco.Forms"])[1]'

if(-not($cloudFormsVersion.Node.Attributes.GetNamedItem("Version").Value -eq 
    $sourceFormsVersion.Node.Attributes.GetNamedItem("Version").Value))
{
    Write-Error "Umbraco.Forms version is different. Possibly due to auto upgrade. Aborting release"
    exit(1)
}

#check umbraco deploy
$cloudDeployVersion = Select-XML -xml $cloudXml -XPath '(//PackageReference[@Include="Umbraco.Deploy.Cloud"])[1]'
$sourceDeployVersion = Select-XML -xml $sourceXml -XPath '(//PackageReference[@Include="Umbraco.Deploy.Cloud"])[1]'

if(-not($cloudDeployVersion.Node.Attributes.GetNamedItem("Version").Value -eq 
    $sourceDeployVersion.Node.Attributes.GetNamedItem("Version").Value))
{
    Write-Error "Umbraco.Deploy.Cloud version is different. Possibly due to auto upgrade. Aborting release"
    exit(1)
}

$cloudDeployVersion = Select-XML -xml $cloudXml -XPath '(//PackageReference[@Include="Umbraco.Deploy.Contrib"])[1]'
$sourceDeployVersion = Select-XML -xml $sourceXml -XPath '(//PackageReference[@Include="Umbraco.Deploy.Contrib"])[1]'

if(-not($cloudDeployVersion.Node.Attributes.GetNamedItem("Version").Value -eq 
    $sourceDeployVersion.Node.Attributes.GetNamedItem("Version").Value))
{
    Write-Error "Umbraco.Deploy.Contrib version is different. Possibly due to auto upgrade. Aborting release"
    exit(1)
}

$cloudDeployVersion = Select-XML -xml $cloudXml -XPath '(//PackageReference[@Include="Umbraco.Deploy.Forms"])[1]'
$sourceDeployVersion = Select-XML -xml $sourceXml -XPath '(//PackageReference[@Include="Umbraco.Deploy.Forms"])[1]'

if(-not($cloudDeployVersion.Node.Attributes.GetNamedItem("Version").Value -eq 
    $sourceDeployVersion.Node.Attributes.GetNamedItem("Version").Value))
{
    Write-Error "Umbraco.Deploy.Forms version is different. Possibly due to auto upgrade. Aborting release"
    exit(1)
}

#check cloud identity
$cloudIdVersion = Select-XML -xml $cloudXml -XPath '(//PackageReference[@Include="Umbraco.Cloud.Identity.Cms"])[1]'
$sourceIdVersion = Select-XML -xml $sourceXml -XPath '(//PackageReference[@Include="Umbraco.Cloud.Identity.Cms"])[1]'

if(-not($cloudIdVersion.Node.Attributes.GetNamedItem("Version").Value -eq 
    $sourceIdVersion.Node.Attributes.GetNamedItem("Version").Value))
{
    Write-Error "Umbraco.Cloud.Identity.Cms version is different. Possibly due to auto upgrade. Aborting release"
    exit(1)
}

#check blob storage
$cloudBlobVersion = Select-XML -xml $cloudXml -XPath '(//PackageReference[@Include="Umbraco.Cloud.StorageProviders.AzureBlob"])[1]'
$sourceBlobVersion = Select-XML -xml $sourceXml -XPath '(//PackageReference[@Include="Umbraco.Cloud.StorageProviders.AzureBlob"])[1]'

if(-not($cloudBlobVersion.Node.Attributes.GetNamedItem("Version").Value -eq 
    $sourceBlobVersion.Node.Attributes.GetNamedItem("Version").Value))
{
    Write-Error "Umbraco.Cloud.StorageProviders.AzureBlob version is different. Possibly due to auto upgrade. Aborting release"
    exit(1)
}