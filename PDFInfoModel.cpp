#include "PDFInfoModel.h"

PDFInfoModel::PDFInfoModel(QObject *parent)
    : QAbstractListModel{parent}
{}

int PDFInfoModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return static_cast<int>(m_pdfList.size());
}

QVariant PDFInfoModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_pdfList.size())
        return QVariant();

    const PDFInfo &info = m_pdfList.at(index.row());
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
    return roles;
}

// void PDFInfoModel::setPDFList(const QVariantList &list)
// {
//     QVector<PDFInfo> newList;
//     for (const QVariant &item : list) {
//         QVariantMap map = item.toMap();
//         PDFInfo info;
//         info.pdfSetName = map.value("pdfSetName").toString();
//         info.QMax = map.value("QMax").toDouble();
//         info.QMin = map.value("QMin").toDouble();
//         newList.push_back(info);
//     }
//     // Now update your internal model.
//     beginResetModel();
//     m_pdfList = newList;
//     endResetModel();
// }

void PDFInfoModel::fillPDFInfoModel()
{
    beginResetModel();
    m_pdfList = m_pdfSetProvider.getPDFSets();
    endResetModel();
}

void PDFInfoModel::cLearModel()
{
    beginResetModel();
    m_pdfList.clear();
    endResetModel();
}

QVariantMap PDFInfoModel::get(int index) const {
    QVariantMap result;
    if (index >= 0 && index < m_pdfList.size()) {
        QModelIndex modelIndex = createIndex(index, 0);
        result["pdfSetName"] = data(modelIndex, PdfSetNameRole);
        result["QMax"] = data(modelIndex, QMaxRole);
        result["QMin"] = data(modelIndex, QMinRole);
        result["XMax"] = data(modelIndex, XMaxRole);
        result["XMin"] = data(modelIndex, XMinRole);
        result["Format"] = data(modelIndex, FormatRole);
        result["Flavors"] = data(modelIndex, FlavorsRole);
        result["OrderQCD"] = data(modelIndex, OrderQCDRole);
    }
    return result;
}
