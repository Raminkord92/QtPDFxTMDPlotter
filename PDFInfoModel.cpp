#include "PDFInfoModel.h"

PDFInfoModel::PDFInfoModel(QObject *parent)
    : QAbstractListModel{parent}
{
    m_pdfList = m_pdfSetProvider.getPDFSets(); // Load all PDF sets initially
    m_filteredPdfList = m_pdfList;            // Initially, no filtering
}

int PDFInfoModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return static_cast<int>(m_filteredPdfList.size()); // Use filtered list
}

QVariant PDFInfoModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_filteredPdfList.size())
        return QVariant();

    const PDFInfo &info = m_filteredPdfList.at(index.row());
    if (role == PdfSetNameRole || role == Qt::DisplayRole)
        return info.pdfSetName;
    else if (role == QMaxRole)
        return info.QMax;
    else if (role == QMinRole)
        return info.QMin;
    else if (role == XMaxRole)
        return info.XMax;
    else if (role == XMinRole)
        return info.XMin;
    else if (role == KtMinRole)
        return info.KtMin;
    else if (role == KtMaxRole)
        return info.KtMax;
    else if (role == PDFSetType)
        return Utils::ConvertPDFSetTypeToString(info.pdfSetType);
    else if (role == FormatRole)
        return QString::fromStdString(info.Format);
    else if (role == FlavorsRole)
        return Utils::CovertFlavorsVecToStr(info.Flvors);
    else if (role == OrderQCDRole)
        return Utils::ConvertOrderQCDToString(info.orderQCD);
    return QVariant();
}

QHash<int, QByteArray> PDFInfoModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[PdfSetNameRole] = "pdfSetName";
    roles[QMaxRole] = "QMax";
    roles[QMinRole] = "QMin";
    roles[XMaxRole] = "XMax";
    roles[XMinRole] = "XMin";
    roles[FormatRole] = "Format";
    roles[FlavorsRole] = "Flavors";
    roles[OrderQCDRole] = "OrderQCD";
    roles[KtMinRole] = "KtMin";
    roles[KtMaxRole] = "KtMax";
    roles[PDFSetType] = "PDFSetType";
    return roles;
}

void PDFInfoModel::fillPDFInfoModel()
{
    beginResetModel();
    m_pdfList = m_pdfSetProvider.getPDFSets();
    m_filteredPdfList = m_pdfList; // Reset filtered list to full list
    endResetModel();
}

void PDFInfoModel::filterByPDFType(const QString &pdfType)
{
    beginResetModel();
    m_filteredPdfList.clear();
    for (const auto &pdf : m_pdfList) {
        if (Utils::ConvertPDFSetTypeToString(pdf.pdfSetType) == pdfType) {
            m_filteredPdfList.append(pdf);
        }
    }
    endResetModel();
}

void PDFInfoModel::cLearModel()
{
    beginResetModel();
    m_pdfList.clear();
    m_filteredPdfList.clear();
    endResetModel();
}

QVariantMap PDFInfoModel::get(int index) const
{
    QVariantMap result;
    if (index >= 0 && index < m_filteredPdfList.size()) { // Use filtered list
        QModelIndex modelIndex = createIndex(index, 0);
        result["pdfSetName"] = data(modelIndex, PdfSetNameRole);
        result["QMax"] = data(modelIndex, QMaxRole);
        result["QMin"] = data(modelIndex, QMinRole);
        result["XMax"] = data(modelIndex, XMaxRole);
        result["XMin"] = data(modelIndex, XMinRole);
        result["Format"] = data(modelIndex, FormatRole);
        result["Flavors"] = data(modelIndex, FlavorsRole);
        result["OrderQCD"] = data(modelIndex, OrderQCDRole);
        result["KtMin"] = data(modelIndex, KtMinRole);
        result["KtMax"] = data(modelIndex, KtMaxRole);
        result["PDFSetType"] = data(modelIndex, PDFSetType);
    }
    return result;
}

int PDFInfoModel::pdfCount() const
{
    return m_filteredPdfList.size(); // Use filtered list
}

bool PDFInfoModel::pdfSetAlreadyExists(const QString &pdfSetName)
{
    for (const auto &pdfSet : m_filteredPdfList) { // Use filtered list
        if (pdfSet.pdfSetName.toLower() == pdfSetName.toLower())
            return true;
    }
    return false;
}
