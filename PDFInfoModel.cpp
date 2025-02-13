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
    if (role == PdfSetNameRole)
        return QString::fromStdString(info.pdfSetName);
    else if (role == MuMaxRole)
        return info.muMax;
    else if (role == MuMinRole)
        return info.muMin;

    return QVariant();
}

QHash<int, QByteArray> PDFInfoModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[PdfSetNameRole] = "pdfSetName";
    roles[MuMaxRole] = "muMax";
    roles[MuMinRole] = "muMin";
    return roles;
}

void PDFInfoModel::setPDFList(const QVariantList &list)
{
    std::vector<PDFInfo> newList;
    for (const QVariant &item : list) {
        QVariantMap map = item.toMap();
        PDFInfo info;
        info.pdfSetName = map.value("pdfSetName").toString().toStdString();
        info.muMax = map.value("muMax").toDouble();
        info.muMin = map.value("muMin").toDouble();
        newList.push_back(info);
    }
    // Now update your internal model.
    beginResetModel();
    m_pdfList = newList;
    endResetModel();
}
